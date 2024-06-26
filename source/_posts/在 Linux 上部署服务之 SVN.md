---
title: 在 Linux 上部署服务之 SVN
abbrlink: "81178978"
date: 2023-07-20 00:46:04
updated: 2023-09-08 16:48:35
tags:
  - linux
  - svn
---

## 0. 准备工作

```bash
# 在系统中创建用来运行 svn 进程的账户
user add -m svn
# 创建相关目录
su svn
mkdir /home/svn/svn_repos/
mkdir /home/svn/log
touch /home/svn/log/svn.log
mkdir /home/svn/svn_users.conf
cd /home/svn/svn_repos/
```

## 1. 创建仓库

```bash
svnadmin create test1
svnadmin create test2
```

## 2. 修改仓库配置

- svnserve.conf

```ini
# cat test1/conf/svnserve.conf
[general]
anon-access = none
auth-access = write
password-db = /home/svn/svn_users.conf/passwd
authz-db = /home/svn/svn_users.conf/authz
realm = test1
```

```ini
# cat test2/conf/svnserve.conf
[general]
anon-access = none
auth-access = write
password-db = /home/svn/svn_users.conf/passwd
authz-db = /home/svn/svn_users.conf/authz
realm = test2
```

修改完 `svnserve.conf` 后必须重启 svn 服务，修改下面两个文件无需重启 svn 服务

## 3. 创建仓库间公用的认证文件

- passwd

```ini
# cat /home/svn/svn_users.conf/passwd
[users]
admin = admin
user1 = user1
user2 = user2
```

- authz

```ini
# cat /home/svn/svn_users.conf/authz
[groups]
Admin = admin,user1
Dev = user1,user2

[test1:/]
@Admin = rw
@Dev = rw
* =

[test2:/]
@Admin = rw
@Dev = r
* =
```

## 4. 设定开机自启

创建/修改 `/etc/systemd/system/svn.service`

```ini
# cat /etc/systemd/system/svn.service
[Unit]
Description=Subversion Server
After = network.target syslog.target
Wants = network.target

[Service]
User=svn
Group=svn
Type=forking
ExecStart=/usr/bin/svnserve --daemon --log-file /home/svn/log/svn.log --root /home/svn/svn_repos
ExecStop=/usr/bin/killall svnserve
Restart=always

[Install]
WantedBy=default.target
```

然后

```bash
mkdir /home/svn/log/
touch /home/svn/log/svn.log # 创建日志文件
systemctl daemon-reload # 刷新systemd配置
systemctl start svn # 启动svn
systemctl enable svn # 设定开机自启
```

## 5. 测试

```bash
svn co svn://localhost/test1 test1 --username admin --password admin
svn add path/to/file
svn ci -m 'xxxxx' --username admin --password admin
```

The end...
