---
title: 向linux系统添加磁盘并挂载
abbrlink: 894ec163
date: 2024-11-23 21:33:02
updated: 2024-11-23 22:29:34
tags:
  - linux
  - fdisk
---

前情提要：

同事的虚拟机硬盘满了，下面是我教同事给虚拟机添加硬盘时记录的操作步骤。虽然网上早已有很多资料了，但我写都写了，稍作整理水一篇博客岂不美哉 o(_￣ ▽ ￣_) ブ

## 1. 添加硬盘

咋添加就不再赘述了 ，添加完硬盘后重启虚拟机，执行 lsblk 命令可以发现会多出 sdb、sdc 之类的设备。这就是咱刚才添加的硬盘。

## 2. 确认哪些目录需要更大空间

使用 `du --max-depth=1 -h /` 可查出哪些目录占占空间较多。  
最终查出来就是这些了：

- /home
- /var  
  …  
  …

以 home 为例吧

## 3. 分区

```bash
root@host45:~# fdisk /dev/sdb
n
疯狂回车
w
```

解释：

- fdisk：分区工具
- n：在硬盘上新建分区
- 疯狂回车：因为是新增空白盘，所以可以大胆的用默认的配置
- w：保存配置，并写入磁盘

然后在刚才创建的分区上创建 ext4 文件系统~~（或者说格式化为 ext4 文件系统）~~

```bash
root@host45:~# mkfs.ext4 /dev/sdb1
```

## 4. 临时挂载

创建一个临时目录作为刚才/dev/sdb1 的挂载点 ，并挂载上去。  
~~这里直接使用 /mnt/home 了，到第 5 步使用 rsync 拷贝数据时会方便点。~~

```bash
root@host45:~# mkdir  /mnt/home
root@host45:~# mount /dev/sdb1 /mnt/home
```

然后再 lsblk 可以看到 sdb1 已被挂载到 /mnt/home

```bash
root@host45:~# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sdb      8:16   0   40G  0 disk
`-sdb1   8:17   0   40G  0 part /mnt/home
```

## 5. 迁移数据

```bash
root@host45:~# rsync -avzuP /home /mnt/
```

作用：同步 /home 下的数据 到 /mnt/home

可以再多执行几次 `rsync -avzuP /home /mnt/`，已被拷贝的不会重新拷贝。~~（不多执行应该也没啥问题，但多执行几次更稳妥一些，突出一个稳健）~~

再执行几次 sync 倒一下缓存。~~（理由同上）~~

```bash
root@host45:~# sync
root@host45:~# sync
```

## 6. 清理掉原来的文件

```bash
root@host45:~# find /home -type f -delete
```

~~用 `rm -rf /home/*` 也行~~，这俩命令都**很危险，执行务必前看清楚敲对了没**，别把 `/` 给清了。

## 7. 持久化挂载

编辑 /etc/fstab，在末尾新建一行添加：

```bash
/dev/sdb1 /home auto auto 0 0
```

说明：

- `/dev/sdb1`：哪个分区
- `/home`：挂载到哪
- `auto auto 0 0`： 不知道该咋写就这样写就没毛病，通用默认配置

## 8. 重启

重启前注意下，第 7 步如果写错，充启后可能会进不去操作系统！~~进安全模式或者单用户模式啥的修改 fstab 文件可解，但不是本文内容了，网络上有很多相关文章，可自行搜索~~

```bash
reboot
```

重新进入系统后你会发现，空间又够用啦~
