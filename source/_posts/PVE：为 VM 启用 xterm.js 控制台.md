---
title: PVE：为 VM 启用 xterm.js 控制台
abbrlink: e393644d
updated: 2023-09-04T04:54:00
date: 2023-08-30T09:42:00
tags:
  - linux
  - pve
---

### 关闭 VM，并给 VM 添加一个 serial port

在 PVE Host 中用 qm 命令建立 serial port，假设我的 VM ID 是 100

```bash
qm set 100 -serial0 socket
```

接着重开 VM，用 dmesg 确认是否有 ttyS 出現

```bash
dmesg | grep ttyS
```

### VM 内修改 grub 配置

依照官方说明，修改 /etc/default/grub 的 GRUB_CMDLINE_LINUX 参数，在，添加 `console=tty0 console=ttyS0,115200`

deb/rpm 系发行版有不同的更新 grub 配置文件的方式

```bash
# deb
update-grub
# rpm
grub2-mkconfig --output=/boot/grub2/grub.cfg
```

最后重启 VM

然后可以在浏览器内打开 PVE 界面测试 xterm.js 是否可用

也可以在 PVE Host 的终端内执行 `qm terminal 100` 来连接到 VM
