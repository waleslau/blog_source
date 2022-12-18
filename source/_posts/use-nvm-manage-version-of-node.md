---
title: 使用 nvm 快速安装和使用不同版本的 node
date: 2022-04-22 20:35:35
updated: 2022-04-22 20:35:35
mermaid: false
math: false
tags:
  - nvm
  - node
  - npm
---

> `nvm` 的全名是 Node Version Manager[^1]，是一个 node.js 的版本管理器，可以帮助用户通过命令行快速安装和使用不同版本的 node。它可以在任何兼容 POSIX 的 shell（sh、dash、ksh、zsh、bash）上工作，比如 Linux、UNIX、macOS 和 Windows WSL。

## 安装

只需要在终端执行下面这行命令

```bash
curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm/install.sh | bash
```

> 一般情况下，该安装脚本会尝试自动处理用户配置文件，可以在安装后执行一下 `nvm` 检查是否成功。如果没有找到 `nvm` 命令，可以手动在 shell 的用户配置文件添加如下内容（`bash` 对应的是 `~/.bashrc`，`zsh` 对应的是 `~/.zshrc`，其他 shell 请自行查询配置文件位置）

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
```

## 简单使用

```bash
nvm install lts/* # 下载最新的LTS版本
nvm use lts/* # 使用最新的LTS版本
nvm alias default lts/* # 设置最新的LTS版本为默认
```

然后检查一下配置是否生效

```bash
$ which npm
/home/idea/.nvm/versions/node/v16.14.2/bin/npm
$ which node
/home/idea/.nvm/versions/node/v16.14.2/bin/node
```

更多使用姿势请自行搜索

[^1]: [https://github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm)
