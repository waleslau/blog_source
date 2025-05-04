---
title: 使用 nvm 快速安装和使用不同版本的 node
abbrlink: 77399d91
date: 2022-04-22 12:46:00
updated: 2023-02-06 14:00:00
tags:
  - node
  - npm
---

> 2023 年 2 月 6 日更新：

总感觉 nvm 载入有点慢，目前切换到了 [n](https://github.com/tj/n),使用方式：

直接执行下面命令即可

```bash
sudo bash <(curl -L https://raw.gitmirror.com/tj/n/master/bin/n) lts
```

默认情况下会把程序下载到 `/usr/local/n/`，所以需要 `sudo`，如果想安装到其他位置，需要先处理一下环境变量才能正常工作，比如：

```bash
export N_PREFIX=$HOME/.n
export PATH="$HOME/.n/bin:$PATH"
```

---

> 下面是之前的内容

nvm 的全名是 [Node Version Manager](https://github.com/nvm-sh/nvm)，是一个 node.js 的版本管理器，可以帮助用户通过命令行快速安装和使用不同版本的 node。nvm 可以在任何兼容 POSIX 的 shell（sh、dash、ksh、zsh、bash）上工作，尤其是在 unix、macOS 和 windows WSL。

## 安装

```bash
curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm/install.sh | bash
```

请在安装后执行一下 `nvm` 检查是否成功，该安装脚本会尝试自动处理 `~/.bashrc`，如果没有找到 `nvm` 命令，可以手动在 shell 的用户配置文件添加如下内容（`zsh` 对应的是 `~/.zshrc`，其他 shell 请自行查询用户配置位置）

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
```

## 首次使用

```bash
nvm install --lts # 下载最新的LTS版本
```

然后检查一下配置是否生效

```bash
$ which npm
/home/idea/.nvm/versions/node/v16.14.2/bin/npm
$ which node
/home/idea/.nvm/versions/node/v16.14.2/bin/node
```

## 更改 npmmirror 中国镜像站

```bash
npm config set registry https://registry.npmmirror.com
```

更多使用姿势请自行搜索
