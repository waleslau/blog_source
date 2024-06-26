---
title: 使用 frp 把内网服务暴露到公网
abbrlink: 16f5231f
date: 2022-12-20 13:13:39
updated: 2022-12-20 13:59:41
tags:
  - frp
---

## frp 介绍

frp 是一个专注于内网穿透的反向代理工具，支持 TCP、UDP、HTTP、HTTPS 等多种协议。可以将内网服务通过具有公网 IP 节点的中转暴露到公网。

软件安装以及自建服务端可以去[官方文档](https://gofrp.org/docs/)查看

## 免费平台推荐

1. [Sakura Frp](https://www.natfrp.com/)（体验好，有国内节点，需要注册账号，建立 http 通道绑定的域名需要备案）
2. [免费 FRP 内网穿透](https://freefrp.net/docs)（体验略逊于上面，但无需注册，建立 http 通道需要自己的域名，无需备案）

## 配置示例

### 通过 SSH 访问内网机器

```ini
[common]
server_addr = frp.freefrp.net
server_port = 7000
token = freefrp.net

[ssh_484939d2_tcp]
type = tcp
local_ip = 127.0.0.1 # 自己机器的ip，本机部署就是127.0.0.1
local_port = 22 # 本地提供服务的ip地址
remote_port = 39317 # 映射到公网的哪个端口，（启动后如果无法访问就换个端口
```

然后可以使用 `ssh ssh://root@frp.freefrp.net:39317` 连接到内网设备

### 通过自定义域名访问内网的 Web 服务

```ini
[common]
server_addr = frp.freefrp.net
server_port = 7000
token = freefrp.net

[test_your_domain_http]
type = http
local_ip = 127.0.0.1
local_port = 8080
custom_domains = test.your.domain
subdomain = test
```

然后可以使用 `http://test.your.domain` 访问你内网部署的网站

更多示例详见：[示例 | frp](https://gofrp.org/docs/examples/)
