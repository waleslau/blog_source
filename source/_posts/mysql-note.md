---
title: MySQL 学习笔记
date: 2019-11-06 11:19:27
updated: 2019-11-06 11:19:27
mermaid: false
math: false
tags:
  - mysql
---

这是我在看「廖雪峰的 SQL 教程」[^1]时记录的笔记

## SQL 简介

SQL = Structured Query Language( 结构化查询语言 )

SQL 语言定义了这么几种操作数据库的能力：

- DDL：Data Definition Language

  DDL 允许用户定义数据，也就是创建表、删除表、修改表结构这些操作。通常，DDL 由数据库管理员执行。

- DML：Data Manipulation Language

  DML 为用户提供添加、删除、更新数据的能力，这些是应用程序对数据库的日常操作。

- DQL：Data Query Language

  DQL 允许用户查询数据，这也是通常最频繁的数据库日常操作。

## 数据库类别

- 关系型数据库
  - MySQL
  - SQLite
  - Microsoft SQL Server
  - Oracle
  - PostgreSQL
- 非关系型数据库
  - MongoDB
  - HBase
  - Cassandra
  - Dynamo
    > 以上所举并非全部

## 关系模型

### 主键

主键是关系表中记录的唯一标识。选取主键的一个基本原则是：不使用任何业务相关的字段作为主键。

### 外键

外键是用来关联 2 个表结构的，表直接的约束分为以下 3 种：

1. 一对一
   - 一个表的记录对应到另一个表的唯一一个记录。
2. 一对多
   - 通过一个表的外键关联到另一个表
3. 多对多
   - 通过一个中间表，关联两个一对多关系，就形成了多对多关系

### 索引

索引是关系数据库中对某一列或多个列的值进行预排序的数据结构。通过使用索引，可以让数据库系统不必扫描整个表，而是直接定位到符合条件的记录，这样就大大加快了查询速度。

> 关于主键、外键、索引请到[ SQL 教程-关系模型](https://www.liaoxuefeng.com/wiki/1177760294764384/1218728991649984)查看详细解释

```sql
-- 这是SQL笔记所用DB源文件（来自廖雪峰的SQL教程）
-- 连接到数据库后这部分代码块复制粘贴到命令行执行即可
-- 如果test数据库不存在，就创建test数据库：
CREATE DATABASE IF NOT EXISTS test;

-- 切换到test数据库
USE test;

-- 删除classes表和students表（如果存在）：
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS students;

-- 创建classes表：
CREATE TABLE classes (
    id BIGINT NOT NULL AUTO_INCREMENT, -- 设置id为自增整数类型
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id) --设置id为主键
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 创建students表：
CREATE TABLE students (
    id BIGINT NOT NULL AUTO_INCREMENT,
    class_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(1) NOT NULL,
    score INT NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入classes记录：
INSERT INTO classes(id, name) VALUES (1, '一班');
INSERT INTO classes(id, name) VALUES (2, '二班');
INSERT INTO classes(id, name) VALUES (3, '三班');
INSERT INTO classes(id, name) VALUES (4, '四班');

-- 插入students记录：
INSERT INTO students (id, class_id, name, gender, score) VALUES (1, 1, '小明', 'M', 90);
INSERT INTO students (id, class_id, name, gender, score) VALUES (2, 1, '小红', 'F', 95);
INSERT INTO students (id, class_id, name, gender, score) VALUES (3, 1, '小军', 'M', 88);
INSERT INTO students (id, class_id, name, gender, score) VALUES (4, 1, '小米', 'F', 73);
INSERT INTO students (id, class_id, name, gender, score) VALUES (5, 2, '小白', 'F', 81);
INSERT INTO students (id, class_id, name, gender, score) VALUES (6, 2, '小兵', 'M', 55);
INSERT INTO students (id, class_id, name, gender, score) VALUES (7, 2, '小林', 'M', 85);
INSERT INTO students (id, class_id, name, gender, score) VALUES (8, 3, '小新', 'F', 91);
INSERT INTO students (id, class_id, name, gender, score) VALUES (9, 3, '小王', 'M', 89);
INSERT INTO students (id, class_id, name, gender, score) VALUES (10, 3, '小丽', 'F', 85);

-- OK:
SELECT 'ok' as 'result:';
```

## 查

#### 1. 基本查询

```sql
SELECT * FROM <表名>
```

- 也可用于简单计算(聊胜于无)

```sql
SELECT 100+200;
```

> 不带 FROM 子句的 SELECT 语句有一个有用的用途，就是用来判断当前到数据库的连接是否有效。许多检测工具会执行一条 SELECT 1;来测试数据库连接。

#### 2. 条件查询

```sql
SELECT * FROM <表名> WHERE <条件表达式>
-- 满足条件1并且满足条件2
SELECT * FROM <表名> WHERE <条件表达式1> AND <条件表达式2>
-- 满足条件1或者满足条件2
SELECT * FROM <表名> WHERE <条件表达式1> OR <条件表达式2>

-- 如果不加括号，条件运算按照NOT、AND、OR的优先级进行，即NOT优先级最高，其次是AND，最后是OR。加上括号可以改变优先级。
--
```

##### 常用的条件表达式

| 条件                 | 表达式举例 1    |   表达式举例 2   | 说明                                                |
| :------------------- | :-------------- | :--------------: | :-------------------------------------------------- |
| 使用=判断相等        | score = 80      |   name = 'abc'   | 字符串需要用单引号括起来                            |
| 使用>判断大于        | score > 80      |   name > 'abc'   | 字符串比较根据 ASCII 码，中文字符比较根据数据库设置 |
| 使用>=判断大于或相等 | score >= 80     |  name >= 'abc'   |                                                     |
| 使用<判断小于        | score < 80      |  name <= 'abc'   |                                                     |
| 使用<=判断小于或相等 | score <= 80     |  name <= 'abc'   |                                                     |
| 使用<>判断不相等     | score <> 80     |  name <> 'abc'   |                                                     |
| 使用 LIKE 判断相似   | name LIKE 'ab%' | name LIKE '%bc%' | %表示任意字符，例如'ab%'将匹配'ab'，'abc'，'abcd'   |

> 在 where like 的条件查询中，SQL 提供了四种匹配方式。
>
> 1. **%**：表示任意 0 个或多个字符。可匹配任意类型和长度的字符，有些情况下若是中文，请使用两个百分号（%%）表示。
> 2. **\_**：表示任意单个字符。匹配单个任意字符，它常用来限制表达式的字符长度语句。
> 3. **[]**：表示括号内所列字符中的一个（类似正则表达式）。指定一个字符、字符串或范围，要求所匹配对象为它们中的任一个。
> 4. **[^]** ：表示不在括号所列之内的单个字符。其取值和 [] 相同，但它要求所匹配对象为指定字符以外的任一个字符。
> 5. 查询内容包含通配符时,由于通配符的缘故，导致我们查询特殊字符 “%”、“\_”、“[” 的语句无法正常实现，而把特殊字符用 “[ ]” 括起便可正常查询。

#### 3. 投影查询(查询表的指定列)

```sql
SELECT 列1, 列2, 列3 FROM ...
-- 查询结果显示自定义列名
SELECT 列1 别名1, 列2 别名2, 列3 别名3 FROM ...
```

#### 4. 排序

```sql
-- 默认排序规则:ASC(从小到大)
SELECT ... ORDER BY <列名>
-- DESC(从大到小)
SELECT ... ORDER BY <列名> DESC
-- 若列名1有相同的数据，要进一步排序，可以继续添加列名
SELECT ... ORDER BY <列名1> <列名2>
```

#### 5. 分页查询

```sql
-- 正常查询
SELECT * FROM <表名>
-- 从结果中截取出M条记录
SELECT * FROM <表名> LIMIT <M>
-- 从结果中截取出从第N+1条记录开始的M条记录
SELECT * FROM <表名> LIMIT <M> OFFSET <N>

-- OFFSET超过了查询的最大数量并不会报错，而是得到一个空的结果集
```

#### 6. 聚合查询

```sql
-- 查询某张表一共有多少条记录
SELECT COUNT(*) FROM <表名>
-- 给它设置一个别名num,便于处理结果
SELECT COUNT(*) num FROM <表名>
-- 使用聚合查询并设置WHERE条件
SELECT COUNT(*) boys FROM students WHERE class_id = '2';

-- 特别注意：
-- 如果聚合查询的WHERE条件没有匹配到任何行
-- COUNT()会返回0，
-- 而SUM()、AVG()、MAX()和MIN()会返回NULL：
```

除了`COUNT()`函数外，SQL 还提供了如下聚合函数：

| 函数 | 说明                                   |
| :--- | :------------------------------------- |
| SUM  | 计算某一列的合计值，该列必须为数值类型 |
| AVG  | 计算某一列的平均值，该列必须为数值类型 |
| MAX  | 计算某一列的最大值                     |
| MIN  | 计算某一列的最小值                     |

注意，`MAX()`和`MIN()`函数并不限于数值类型。如果是字符类型，`MAX()`和`MIN()`会返回排序最后和排序最前的字符。

##### 分组聚合

```sql
-- 按class_id分组:
SELECT COUNT(*) num FROM students GROUP BY class_id;
--
select
class_id 班级, count(*) 人数 , avg(score) 平均分
from students
group by class_id;
--
```

#### 7. 多表查询

```sql
--
SELECT * FROM <表1> <表2>
-- set alias 给列设置别名:
SELECT
    students.id sid,
    students.name,
    students.gender,
    students.score,
    classes.id cid,
    classes.name cname
FROM students, classes;
-- set table alias 给表设置别名:
SELECT
    s.id sid,
    s.name,
    s.gender,
    s.score,
    c.id cid,
    c.name cname
FROM students s, classes c;
-- 多表查询添加WHERE条件
SELECT
    s.id sid,
    s.name,
    s.gender,
    s.score,
    c.id cid,
    c.name cname
FROM students s, classes c
WHERE s.gender = 'M' AND c.id = 1;
```

#### 8. 连接查询

```sql
-- 选出所有学生
SELECT s.id, s.name, s.class_id, s.gender, s.score FROM students s;

-- 选出所有学生，同时返回班级名称
-- 常用的一种内连接 INNER JOIN
SELECT s.id, s.name, s.class_id, c.name class_name, s.gender, s.score
FROM students s
INNER JOIN classes c
ON s.class_id = c.id;

-- 使用外连接 OUTER JOIN
SELECT s.id, s.name, s.class_id, c.name class_name, s.gender, s.score
FROM students s
RIGHT OUTER JOIN classes c
ON s.class_id = c.id;

-- INNER JOIN只返回同时存在于两张表的行数据
-- RIGHT OUTER JOIN返回右表存在的行。如果某一行仅在右表存在，那么结果集就会以NULL填充剩下的字段
-- LEFT OUTER JOIN返回左表存在的行。如果某一行仅在左表存在，那么结果集就会以NULL填充剩下的字段
-- FULL OUTER JOIN，它会把两张表的所有记录全部选择出来，并且，自动把对方不存在的列填充为NULL：
```

> INNER JOIN(内连接)查询的写法：
>
> 1. 先确定主表，仍然使用`FROM <表1>`的语法；
> 2. 再确定需要连接的表，使用`INNER JOIN <表2>`的语法；
> 3. 然后确定连接条件，使用`ON <条件...>`，这里的条件是`s.class_id = c.id`，表示`students`表的`class_id`列与`classes`表的`id`列相同的行需要连接；
> 4. 可选：加上`WHERE`子句、`ORDER BY`等子句。

_使用别名不是必须的，但可以更好地简化查询语句_

## 增

```sql
INSERT INTO <表名> (字段1, 字段2, ...) VALUES (值1, 值2, ...);
-- 一次性添加多条新记录
INSERT INTO <表名> (字段1, 字段2, ...) VALUES
(A值1, A值2, ...)
(B值1, B值2, ...);
```

## 改

```sql
UPDATE <表名> SET 字段1=值1, 字段2=值2, ... WHERE ...;

-- 可以一次更新多条记录

UPDATE <表名> SET class_id=3  WHERE id=1 AND id>2

-- 在UPDATE语句中，更新字段时可以使用表达式

UPDATE students SET score=score+10 WHERE score<80;

-- 要特别小心，UPDATE语句可以没有WHERE条件
UPDATE students SET score=60;
-- 这时，整个表的所有记录都会被更新。所以，在执行UPDATE语句时要非常小心，最好先用SELECT语句来测试WHERE条件是否筛选出了期望的记录集，然后再用UPDATE更新。
```

## 删

```sql
DELETE FROM <表名> WHERE ...;

-- 和UPDATE类似，DELETE语句也可以一次删除多条记录
-- 删除students表中id在5-7之间的行
DELETE FROM students WHERE id>=5 AND id<=7;
-- 和UPDATE类似，不带WHERE条件的DELETE语句会删除整个表的数据
-- 在执行DELETE语句时也要非常小心，最好先用SELECT语句来测试WHERE条件是否筛选出了期望的记录集，然后再用DELETE删除。
```

[^1]: https://www.liaoxuefeng.com/wiki/1177760294764384
