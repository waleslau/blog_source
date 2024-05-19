---
title: fstab 延迟挂载网络共享磁盘
tags:
  - fstab
abbrlink: e145ca24
date: 2024-05-19 23:20:33
updated: 2024-05-19 23:30:24
---

通过编辑 `/etc/fstab` 文件挂载网络磁盘时，由于操作系统读取 `/etc/fstab` 文件挂载文件系统时操作系统的网络还没起来，无法成功建立连接，一直阻塞后面的启动流程，进而导致启动超时。  
解决方案就是再 `fstab` 里网络磁盘对应行添加一个 `_netdev` 字段，表明当前挂载的设备依赖网络。配置了这个字段后，系统会在确保网络可用后再尝试挂载。  
example：

```bash
/dev/xxx /xxx/xxx ext4 defaults,_netdev 0 0
```
