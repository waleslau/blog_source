---
title: 给 SSH 设置代理
date: 2022-03-05 20:56:41
updated: 2022-03-05 20:56:41
mermaid: false
math: false
categories:
  - tech
tags:
  - ssh
  - proxy
  - git
---

## 前言

学校的校园网不知出于何种考虑封禁了 22 端口，这给我带来了一些麻烦，我无法使用 ssh 链接克隆我的 Git 仓库了，而且有些云服务器的 sshd 如果用的是默认的 22 端口，也将无法建立通信，还有些代码托管平台由于不可抗力也会无法访问。这种情况下就要用到代理了

## Linux / macOS

只需要在 `~/.ssh/config` 添加如下内容:

```yaml
Host <要访问的主机>
 ProxyCommand nc -x 127.0.0.1:1089 %h %p
```

**参数解释**

`Host`后面跟需要要代理的主机名（或 ip 地址），多个主机用空格隔开，如果填写`*`则表示该配置作用于所有主机。

使用 `-X proxy_protocol` 指定代理服务器使用的协议。`4`代表 socks4,`5` 代表 socks5，`connect` 代表 http，如果未使用 `-X` 参数，则默认使用 socks5 协议

使用 `-x proxy_address[:port]` 指定代理服务器和端口

例如：

```yaml
Host github.com gitee.com 111.111.111.111
 ProxyCommand nc -X connect -x 127.0.0.1:8889 %h %p
```

---

如果只是临时使用代理访问服务器的场景，也可以直接使用命令行：

```bash
ssh -o ProxyCommand="nc -x 127.0.0.1:1089 %h %p" user@server
```

## Windows

首先安装 [Git for Windows](https://git-scm.com/download/win)

ssh 的配置文件的位置是`C:\Users\yourName\.ssh\config`，

和 linux 平台的配置不同的是，我们需要把 ProxyCommand 后面的内容改成类似下面这样

```yaml
Host github.com gitee.com 111.111.111.111
 ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -S 127.0.0.1:10808 %h %p
```

**参数解释**

`-S` 代表 socks5，`-H` 代表 http

其他都和 Linux 平台没啥区别
