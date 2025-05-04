---
title: 管理 Linux 用户配置（点文件）的最好方式
abbrlink: 5fa4b291
date: 2023-02-06 14:22:00
updated: 2023-09-24 10:44:37
tags:
  - dotfiles
  - linux
---

## 前言

标题有点违反广告法了哈哈哈，言归正传，作为一个 Linux User，随着时间的推移，我积攒了一大堆自定义的配置文件。有时某些软件会在我不知道的时候自动修改这些文件，这会对我造成一些困扰，而且每次重装系统或在其他设备初始化工作环境时都要一个一个地拷贝它们，这太不优雅了！我得想个办法解决这些问题。经过搜索，我找到了以下几种方式：

1. [【译】使用 GNU stow 管理你的点文件](https://farseerfc.me/zhs/using-gnu-stow-to-manage-your-dotfiles.html)
2. [How to Store Dotfiles - A Bare Git Repository](https://www.atlassian.com/git/tutorials/dotfiles)
3. [chezmoi: Manage your dotfiles across multiple diverse machines, securely.](https://github.com/twpayne/chezmoi)

经过试用/对比，我最终选用了第二个链接内提到的方法，即使用 Bare Git Repository 方式管理。得益于 Git 的强大功能，这种方式主要可以做到以下功能：

- 版本管理
- 监测配置更改
- 多设备同步

这是[我的 dotfiles 仓库](https://github.com/waleslau/dotfiles)，这种方法的所有功能都是通过 git 实现的，只需要往 `.bashrc` 里写入一个命令别名。由于下面有更好的方法，此处不再赘述，感兴趣的话可以看一下我仓库里的 [README.md](https://github.com/waleslau/dotfiles/blob/main/README.md)。

后来我又发现了一个工具：[yadm](https://github.com/TheLocehiliosan/yadm)，这个工具也是基于 Bare Git Repository 设计的，比我原来的方法多了一些挺实用的功能（比如敏感文件加密存储，这个功能其实 git 本身就可以通过[插件](https://git-secret.io/)支持，但没有直接使用 `yadm` 方便就是了），由于底层原理相同，我原来的方法建立的仓库和本工具是完全兼容的，把配置同步到远端仓库后直接 `yadm clone <repo url>` 然后 `yadm checkout $HOME` 就可以无痛切换到新工具了，开森 🥰

## 安装

大多数发行版都可以直接使用包管理工具安装 `yadm`，如果发行版仓库里没有，也可以直接从 Github 仓库下载（这个东西本质上其实就是一个 shell 脚本）

```bash
mkdir -p ~/.local/bin
curl https://fastly.jsdelivr.net/gh/TheLocehiliosan/yadm@master/yadm -o ~/.local/bin/yadm
chmod +x ~/.local/bin/yadm
```

## 使用

```bash
# 初始化一个新仓库
yadm init

# 克隆现有仓库
yadm clone <url>

# 增添文件/应用更改
yadm add <important file>
yadm commit

# 加密存储 ssh 密钥，以安全地同步它
echo '.ssh/id_rsa' > ~/.config/yadm/encrypt
yadm encrypt

# 可以在同步本仓库到其他设备后，解密ssh密钥
yadm decrypt

# 为Linux与MacOS创建不同的文件
yadm add path/file.cfg##os.Linux
yadm add path/file.cfg##os.Darwin
```
