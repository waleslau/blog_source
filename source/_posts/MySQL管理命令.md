---
title: MySQL 管理
mermaid: false
math: false
tags:
  - mysql
abbrlink: 3e4584c0
date: 2020-01-22 22:56:22
updated: 2020-01-22 22:56:22
permalink:
---

登陆数据库系统：

```bash
mysql -h[ip] -P[端口] -u[用户名] -p[密码]  [数据库名_可选]
```

## 用户管理

### 1.创建用户

```sql
-- 创建本地用户
mysql> CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'user_password';
-- 创建用户并授予ip为6.6.6.6的主机访问权限
mysql> CREATE USER 'newuser'@'6.6.6.6' IDENTIFIED BY 'user_password';
-- 创建可以从任何主机连接的用户，使用'%'通配符作为主机部分
mysql> CREATE USER 'newuser'@'%' IDENTIFIED BY 'user_password';
-- 创建本地用户之前检查是否已存在同名用户
CREATE USER IF NOT EXISTS 'newuser'@'localhost' IDENTIFIED BY 'user_password';
```

### 2.赋予用户权限

常用权限：

- `ALL PRIVILEGES` –授予用户帐户所有特权。
- `CREATE`–允许用户帐户创建数据库和表。
- `DROP`-允许用户帐户删除数据库和表。
- `DELETE` -允许用户帐户从特定表中删除行。
- `INSERT` -允许用户帐户在特定表中插入行。
- `SELECT` –允许用户帐户读取数据库。
- `UPDATE` -允许用户帐户更新表行。

  [点击查看更多](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html)

要向用户帐户授予特定特权，可以使用以下语法

```sql
-- 授予特定数据库上的所有特权给某用户帐户
mysql> GRANT ALL PRIVILEGES ON database_name.* TO 'database_user'@'localhost';

-- 授予所有数据库的所有特权给某用户帐户
-- 可以省略 PRIVILEGES
mysql> GRANT ALL  ON *.* TO 'database_user'@'localhost';

-- 授予特定数据库上特定表的所有特权给某用户帐户
mysql> GRANT ALL PRIVILEGES ON database_name.table_name TO 'database_user'@'localhost';

-- -- 授予特定数据库上的多个特权给某用户帐户
mysql> GRANT SELECT, INSERT, DELETE ON database_name.* TO database_user@'localhost';
```

- 显示某用户账户拥有的特权

```sql
mysql> SHOW GRANTS FOR 'database_user'@'localhost';
```

- 撤销某用户账户的特权

```sql
-- 撤消特定数据库上用户帐户的所有特权
mysql> REVOKE ALL PRIVILEGES ON database_name.* FROM 'database_user'@'localhost';
```

- 删除现有的 MySQL 用户帐户

```sql
mysql> DROP USER 'user'@'localhost'
```

## 创建/删除数据库

> 把下面所有命令的 `DROP` 改为 `CREATE` 即为创建之法

- 在数据库视图中

```sql
-- 直接删除
mysql> DROP DATABASE database_name;
-- 若不确定该数据库是否存在
mysql> DROP DATABASE IF EXISTS database_name;
```

- 使用 `mysqladmin`

```bash
$ mysqladmin -u root -p[密码] drop database_name

```

## 数据库导出/导入

### 导出数据库

```bash
$ mysqldump -u[用户名] -p[密码] 数据库名 > /path/to/导出的文件名.sql
```

其他

```bash
## 导出一个表
$ mysqldump -u[用户名] -p[密码] 数据库名 表名 > /path/to/导出的文件名.sql

## 导出一个数据库结构
$ mysqldump -u[用户名] -p[密码] -d --add-drop-table 数据库名  > /path/to/导出的文件名.sql

# 可能用到的一些 mysqldump 参数及其解释

-n, --no-create-db # 禁止生成创建数据库语句
-t, --no-create-info # 禁止生成创建数据库库表语句
-d, --no-data:  # 不包含数据
--add-drop-table # 在每个创建数据库表语句前添加删除数据库表的语句(避免冲突)
```

### 导入数据库

#### 1.创建数据库

```sql
mysql> CREATE DATABASE new_database;
```

#### 1.1 创建用户（可选）

```sql
mysql> CREATE USER "username"@"localhost" IDENTIFIED BY "password";
mysql> GRANT ALL ON new_database.* TO "username"@"localhost";
mysql> FLUSH PRIVILEGES;
```

#### 2.导入数据

> 下面两种方式都需要先创建数据库

- mysql 命令行方式：

```sql
mysql> use new_database

mysql> source /path/to/导出的文件名.sql
```

- 系统命令行方式

```bash
$ mysql -uroot -p[密码] new_database < /path/to/导出的文件名.sql
```
