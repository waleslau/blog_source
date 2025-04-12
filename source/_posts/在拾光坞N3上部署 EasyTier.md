---
title: 在拾光坞N3上部署 EasyTier
abbrlink: ba8cb8ea
date: 2025-04-12 21:37:28
updated: 2025-04-13 01:06:03
tags:
  - 内网穿透
  - 异地组网
  - nas
---

在创建容器时需要注意两点：

一是网络要设置为 host 模式，

二是「命令设置 --> cmd 命令」改成自定义，并填入如下内容：

```yml
'--no-tun' '-d' '--network-name' 'foo' '--network-secret' 'bar' '-p' 'tcp://public.easytier.cn:11010'
```

参数说明：

- `-i <IPV4>`: 手动指定 ip
- `-d`: 自动设定 ip，与 `-i` 二选一
- `--no-tun`: 配置该参数后将不会尝试创建 TUN 设备，该节点将无法主动启动对其他节点的访问，不影响被访问

如此这般，在拾光坞官方内网穿透之外，我又有了一个让其他设备随时访问拾光坞的途径，且更自由。
