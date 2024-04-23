---
title: Redis：初探
abbrlink: 8e5de943
updated: 2024-03-22T17:52:05
date: 2023-08-31T03:26:32
tags:
  - redis
---

## 简介

Redis 是一个典型的 Key-Value 存储系统，或者说非关系型数据库。实际上一个 Redis 实例提供了多个用来存储数据的字典，客户端可以指定将数据存储在哪个字典中。这与我们熟知的在一个关系数据库实例中可以创建多个数据库类似，所以可以将其中的每个字典都理解成一个独立的数据库。

每个数据库对外都是一个从 0 开始的递增数字命名，Redis 默认支持 16 个数据库（可以通过配置文件支持更多，无上限），可以通过配置 databases 来修改这一数字。客户端与 Redis 建立连接后会自动选择 0 号数据库，不过可以随时使用 SELECT 命令更换数据库。

然而这些以数字命名的数据库又与我们理解的数据库有所区别。首先 Redis 不支持自定义数据库的名字，每个数据库都以编号命名，开发者必须自己记录哪些数据库存储了哪些数据。另外 Redis 也不支持为每个数据库设置不同的访问密码，所以一个客户端要么可以访问全部数据库，要么连一个数据库也没有权限访问。最重要的一点是多个数据库之间并不是完全隔离的，比如 FLUSHALL 命令可以清空一个 Redis 实例中所有数据库中的数据。

综上所述，这些数据库更像是一种命名空间，而不适宜存储不同应用程序的数据。比如可以使用 0 号数据库存储某个应用生产环境中的数据，使用 1 号数据库存储测试环境中的数据，但不适宜使用 0 号数据库存储 A 应用的数据而使用 1 号数据库 B 应用的数据，不同的应用应该使用不同的 Redis 实例存储数据。由于 Redis 非常轻量级，一个空 Redis 实例占用的内存只有 1M 左右，所以不用担心多个 Redis 实例会额外占用很多内存。

各个数据类型应用场景：

| 类型                 | 简介                                                         | 特性                                                                                                                                     | 场景                                                                                                           |
| :------------------- | :----------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------- |
| String(字符串)       | 一组字节，且二进制安全（具有已知长度、不受特殊终止字符影响） | 可以包含任何数据,如图片或者序列化的对象,一个键最大能存储 512M                                                                            | ---                                                                                                            |
| Hash(字典)           | 键值对集合,即编程语言中的 Map 类型                           | 适合存储对象,并且可以像数据库中 update 一个属性一样只修改某一项属性值 (Memcached 中需要取出整个字符串反序列化成对象修改完再序列化存回去) | 存储、读取、修改用户属性                                                                                       |
| List(列表)           | 链表 (双向链表)                                              | 增删快,提供了操作某一段元素的 API                                                                                                        | 1、最新消息排行等功能 (比如朋友圈的时间线)<br>2、消息队列                                                      |
| Set(集合)            | 哈希表实现,元素不重复                                        | 1、添加、删除,查找的复杂度都是 O(1)<br>2、为集合提供了求交集、并集、差集等操作                                                           | 1、共同好友<br>2、利用唯一性,统计访问网站的所有独立 ip<br>3、好友推荐时,根据 tag 求交集,大于某个阈值就可以推荐 |
| Sorted Set(有序集合) | 将 Set 中的元素增加一个权重参数 score,元素按 score 有序排列  | 数据插入集合时,已经进行天然排序                                                                                                          | 1、排行榜<br>2、带权重的消息队列                                                                               |

## 操作实例

所有操作的命令行方式及基本代码实现都在 [Redis 官网](https://redis.io/commands/) 有给出，[菜鸟教程](https://www.runoob.com/redis/redis-tutorial.html) 及 [Redis 中文教程](https://redis.com.cn/tutorial.html) 里也有一些信息。

如下所示，我只测试了一些命令行的操作

首先连接到本机启动的 redis 进程的 0 号数据库

```bash
redis-cli -n 0
```

### String（字符串）

```
> SET str01 "no expire"
> SET str02 'expire time is 10 sec' ex 10
> GET str01
> GET str02
```

python：

```python
import redis
r = redis.Redis(host='localhost', port=6379, decode_responses=True)
# r.set('foo', 'bar',ex='5')
r.set('name', 'jack')
print(r['name'])
re = r.get('name')
print(f'value of name is {re}')
```

### Hash（哈希）

```
> HMSET hash01 name jack age 22
> HGET hash01 name
```

### List（列表）

```
> LPUSH list01 python
> LPUSH list01 java
> LPUSH list01 c
> LPUSH list01 mysql
> LPUSH list01 mongodb
> LRANGE list01 0 10
> LPOP list01
> RPOP list01
```

### Set（集合）

```
> SADD set01 zhangsan
> SADD set01 lisi
> SADD set01 wangwu
> SMEMBERS set01
```

### Sorted Set（有序集合）

```
> ZADD zset01 0 python
> ZADD zset01 0 java
> ZADD zset01 0 c
> ZADD zset01 0 go
> ZRANGEBYSCORE zset01 0 100
```

## 备份/还原

使用 SAVE 命令创建当前数据库的备份，重启的时候可以再次加载进行使用。

```
> SAVE
```

该命令将在 redis 安装目录中创建 dump.rdb 文件。

如果需要恢复数据，只需将备份文件 (dump.rdb) 移动到 redis 安装目录并启动服务即可。获取 redis 目录可以使用 `CONFIG GET dir` 命令

创建 redis 备份文件也可以使用命令 `BGSAVE`，该命令在后台执行。

## 持久化

redis 提供了两种持久化的方式，分别是 **RDB**（Redis DataBase）和 **AOF**（Append Only File）。

RDB，简而言之，就是在不同的时间点，将 redis 存储的数据生成快照并存储到磁盘等介质上；

AOF，则是换了一个角度来实现持久化，那就是将 redis 执行过的所有写指令记录下来，在下次 redis 重新启动时，只要把这些写指令从前到后再重复执行一遍，就可以实现数据恢复了。

官方建议两种方式同时使用。这样可以提供更可靠的持久化方案。

## 其他

### 图形化客户端

[Another Redis Desktop Manager](https://github.com/qishibo/AnotherRedisDesktopManager/releases)

### Window 平台服务端

~~以及自带的命令行客户端~~

[Redis for Windows](https://github.com/redis-windows/redis-windows/releases)

> **server init**
>
> 1. 注释掉 `bind 127.0.0.1`（或改为 `bind 0.0.0.0`），否则无法在其他主机访问 redis
> 2. `protected-mode yes` 改为 `protected-mode no`，否则必须配置账户/密码才能连接
> 3. `requirepass password` ，设定访问密码，可选
