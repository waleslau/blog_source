---
title: 使用 davfs2 挂载 webdav
abbrlink: 624431f7
date: 2022-08-06 12:00:00
updated: 2022-12-19 12:40:00
tags:
  - linux
  - webdav
---

首先安装好 davfs2 软件包

## 配置 davfs2

- 编辑 /etc/davfs2/davfs2.conf 取消以下项的注释并更改值

```bash
ignore_dav_header 1
use_locks 0
```

- 配置用户名/密码

编辑 /etc/davfs2/secrets 末尾添加

```bash
https://seto.teracloud.jp/dav/ <username> <secret>
# 也可以有子目录
https://seto.teracloud.jp/dav/dir1/ <username> <secret>
https://seto.teracloud.jp/dav/dir2/ <username> <secret>
```

## 手动挂载

```bash
#创建挂载路径
mkdir /webdav
#手动挂载
mount -t davfs https://seto.teracloud.jp/dav/dir1/ /webdav/dir1/
# 卸载
umount /webdav/dir1/
```

手动挂载测试过没问题后可以配置开机自动挂载

## 自动挂载

编辑 /etc/fstab 末尾添加

```bash
https://seto.teracloud.jp/dav/dir1/ /path/to/dir1/ davfs rw,user,sync,noauto,uid=1000,_netdev 0 0
```

编辑 `etc/systemd/system/mount-webdav.service`

```bash
[Unit]
# 服务名称，可自定义Description=Mount WebDAV Service (KeePass)
After = network.target syslog.target
Wants = network.target

[Service]
Type = oneshot
ExecStart = bash -c 'for i in {1..15}; do if ping -c 1 seto.teracloud.jp; then mount /path/to/dir1/; break; else sleep 1; fi; done'
ExecStop = umount /path/to/dir1/
RemainAfterExit = true

[Install]
WantedBy = multi-user.target
```

然后执行下面命令

```bash
systemctl enable --now keepass-webdav.service
```
