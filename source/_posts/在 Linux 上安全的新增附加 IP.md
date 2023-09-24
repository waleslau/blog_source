---
title: 在 Linux 上安全的新增附加 IP
updated: 2023-09-04T05:35:39
date: 2023-09-04T05:03:41
tags:
  - linux
---

> 不影响原网卡配置，降低故障风险，不影响业务正常运行

## 临时添加：

### 使用 `ip` 命令

```bash
ip addr add 10.100.100.231/24 dev eth0:0
```

### 使用 `ifconfig` 命令

```bash
ifconfig eth0:0 10.100.100.235 netmask 255.255.255.0 up
```

## 永久添加：

### deb 系发行版：

```bash
# cat /etc/network/interfaces
auto ens33
iface ens33 inet static
       address 10.17.34.231
       prefix 24
       gateway 10.17.34.1

auto ens33:0
iface ens33:0 inet static
       address 10.100.100.231
       prefix 24
```

### rpm 系发行版：

```bash
# cat /etc/sysconfig/network-scripts/ifcfg-eno3
DEVICE=eno3
ONBOOT=yes
BOOTPROTO="static"
IPADDR=10.17.34.234
PREFIX=24

# cat /etc/sysconfig/network-scripts/ifcfg-eno3:0
DEVICE=eno3:0
ONBOOT=yes
IPADDR=10.100.100.234
PREFIX=24
```

保存退出，启用网卡 ifup eno3:0 即可。多个 IP 则添加多个文件 `:1`、`:2` ...

配置不同的网卡只需要修改 DEVICE、IPADDR、NETMASK(或者 PREFIX)，网卡配置文件中的变量名都必须是大写。
