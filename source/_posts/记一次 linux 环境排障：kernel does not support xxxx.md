---
title: 记一次 linux 环境排障：kernel does not support xxxx
abbrlink: 1451bb48
date: 2026-08-07 12:01:26
updated: 2026-08-07 12:43:38
tags:
  - linux
---
突然发现 podman 起不来了：

```bash
[idea@amd-yes ~]$ podman images
Error: configure storage:  overlay fs: 'overlay' is not supported over btrfs at "/home/idea/.local/share/containers/storage/overlay": backing file system is unsupported for this graph driver
```

百思不得其解，我也没动啥啊，去社区搜了一下有没有先例，哦🐒，发现一个类似情况的帖子，下面评论里有人让检查一下本机在使用的内核版本以及镜像里的内核版本。

```bash
[idea@amd-yes ~]$ uname -a
Linux amd-yes 7.1.5-arch1-2 #1 SMP PREEMPT_DYNAMIC Tue, 28 Jul 2026 13:49:51 +0000 x86_64 GNU/Linux
[idea@amd-yes ~]$ pacman -Q linux
linux 7.1.6.arch1-1
```

这情况是更新内核后忘记重启了，重启一下就行了。
