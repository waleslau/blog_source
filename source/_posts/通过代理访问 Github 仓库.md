---
title: 通过代理访问 Github 仓库
abbrlink: 6cedfc7a
date: 2022-03-29 14:10:00
updated: 2023-01-17 10:02:04
tags:
  - git
  - proxy
  - ssh
---

众所周知，GitHub 在国内常常因为不可抗力导致访问受限，在此我分享一下我用来提升 GitHub 使用体验的几个姿势

## HTTP

在使用 Git 操作远程仓库时，如果用的是 HTTP 协议，可以直接用下面这样的命令配置（所有支持 Git 的平台都可以这么配置）

> [^1]在代理字符串中，socks5h://表示主机名由 SOCKS 服务器解析。socks5://表示主机名在本地解析。为避免可能存在的 DNS 污染问题，一般建议使用 socks5h

我们可以对所有域名都启用代理（全局）

```bash
git config --global http.proxy socks5h://127.0.0.1:7890
```

也可以分别对某些域名启用代理

```bash
git config --global http.https://github.com.proxy socks5h://127.0.0.1:7890

git config --global http.https://gitlab.com.proxy socks5h://127.0.0.1:7890

# 未在上面配置的域名将不会通过代理
```

~别忘把命令末尾的代理服务器地址改成你自己的~

> 从 2021 年 8 月 13 日开始，GitHub 将在对 Git 操作进行身份验证时不再接受帐户密码，并将要求使用基于令牌（token）的身份验证，[^2]例如个人访问令牌。或者选择使用 SSH 密钥。

也就是说，现在不支持直接使用 https 链接访问私有库了，在不使用 token 的情况下，我们将只能对 GitHub 上的公共仓库进行 clone 操作，当然我们可以选择使用 SSH 。

## SSH

若想要让 SSH 协议也通过代理，只需在 `~/.ssh/config` 添加如下内容:

### Linux / macOS

```config
Host github.com
    ProxyCommand nc -x 127.0.0.1:7890 %h %p
```

### Windows

```config
Host github.com
    ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -S 127.0.0.1:7890 %h %p
```

### 拓展，在 443 端口使用 SSH (仅限 Github[^3])

有时，防火墙会阻断内网客户端对 22 端口的连接，有些机场也会阻断 22 端口，这时可以尝试使用通过 443 端口建立的 SSH 连接

编辑文件 `~/.ssh/config`

```config
Host github.com
    Hostname ssh.github.com
    Port 443
    User git
    ProxyCommand nc -x 127.0.0.1:7890 %h %p
```

然后可以直接使用形似 `git@github.com:user/repo.git` 的克隆链接

 <!-- ~~如果不想改配置，也可以直接使用形似`ssh://git@ssh.github.com:443/user/repo.git`的克隆链接，两种方式是等价的~~ 更正：也需要在`Host`字段添加`ssh.github.com`才能无痛使用。。。总之可以忽略删除线到现在的内容 😂 -->

[^1]: [Differentiate socks5h from socks5...](https://github.com/urllib3/urllib3/issues/1035)
[^2]: [使用令牌访问 GitHub](https://blog.oopsky.top/post/545a5fc3/)
[^3]: [在 HTTPS 端口使用 SSH](https://docs.github.com/cn/authentication/troubleshooting-ssh/using-ssh-over-the-https-port)
