---
title: 突破网络限制访问 GitHub
date: 2022-03-29 22:10:42
updated: 2022-03-29 22:10:42
mermaid: false
math: false
tags:
  - ssh
  - proxy
  - git
---

众所周知，GitHub 在国内常常因为不可抗力导致访问受限，在此我分享一下我用来提升 GitHub 使用体验的几个姿势

## HTTP

在使用 Git 操作远程仓库时，如果用的是 HTTP 协议，可以直接用下面这样的命令配置（所有支持 Git 的平台都可以这么配置）

{% note info %}
[^1]在代理字符串中，socks5h://表示主机名由 SOCKS 服务器解析。socks5://表示主机名在本地解析。为避免可能存在的 DNS 污染问题，一般建议使用 socks5h
{% endnote %}

我们可以对所有域名都启用代理（全局）

```bash
git config --global http.proxy socks5h://127.0.0.1:10808
```

也可以分别对某些域名启用代理

```bash
# 对 GitHub 启用代理，在本地解析域名
git config --global http.https://github.com.proxy socks5://127.0.0.1:10808

# 对 GitHub 启用代理，在 socks 服务器解析域名
git config --global http.https://github.com.proxy socks5h://127.0.0.1:10808

# 对 GitLab 启用代理，在 socks 服务器解析域名
git config --global http.https://gitlab.com.proxy socks5h://127.0.0.1:10808

# 未在上面配置的域名将不会通过代理
```

~别忘把命令末尾的代理服务器地址改成你自己的~

{% note warning %}
从 2021 年 8 月 13 日开始，GitHub 将在对 Git 操作进行身份验证时不再接受帐户密码，并将要求使用基于令牌（token）的身份验证，[^2]例如个人访问令牌。或者选择使用 SSH 密钥。
{% endnote %}

也就是说，现在不支持直接使用 https 链接访问私有库了，在不使用 token 的情况下，我们将只能对 GitHub 上的公共仓库进行 clone 操作，当然我们可以选择使用 SSH 。

## SSH

### 1. 给 ssh 设置代理

只需要在 `~/.ssh/config` 添加如下内容:

#### Linux / macOS

```yaml
Host github.com
ProxyCommand nc -x 127.0.0.1:1089 %h %p
```

#### Windows

```yaml
Host github.com
ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -S 127.0.0.1:10808 %h %p
```

更多信息点我[^3]

### 2. 在 443 端口使用 SSH

{% note warning %}
本方法仅适用于 Github[^4]，未测试其他平台
{% endnote %}

有时，防火墙会阻塞内网客户端对 22 端口的连接，这时可以尝试使用通过 443 端口建立的 SSH 连接

先测试一下连通性

```bash
ssh -T -p 443 git@ssh.github.com
```

如果有回显，说明此方法在你那里可行  
编辑文件 `~/.ssh/config`

```yaml
Host github.com
Hostname ssh.github.com
Port 443
User git
```

{% note success %}
我发现在我这里配置后不用挂代理也有良好的连通性。所以就没加`ProxyCommand`，如果在你那里不行的话可以加上它（注意 Linux/Windos 等系统上的配置的区别）
{% endnote %}

然后测试一下是否可以直接访问`git@github.com`

```bash
ssh -T git@github.com
```

如果显示`Hi username! You've successfully authenticated, but GitHub does not provide shell access.`，则说明配置有效

[^1]: https://github.com/urllib3/urllib3/issues/1035
[^2]: https://blog.oopsky.top/2021/08/github-authenticating-by-personal-access-token
[^3]: https://blog.oopsky.top/2022/03/ssh-over-proxy/
[^4]: https://docs.github.com/cn/authentication/troubleshooting-ssh/using-ssh-over-the-https-port
