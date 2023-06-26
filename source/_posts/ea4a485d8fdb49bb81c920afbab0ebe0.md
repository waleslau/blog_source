---
layout: post
title: 批量重命名阿里云盘里的文件
abbrlink: ea4a485d8fdb49bb81c920afbab0ebe0
tags:
  - aliyundrive
categories:
  - 笔记
date: 1673421167564
updated: 1673422769620
---
1. 运行 [aliyundrive-webdav](https://github.com/messense/aliyundrive-webdav)
2. 挂载到本地
   * Windows ：文件管理器 → 此电脑 → 右键 → 添加一个网络位置
   * Linux ：[使用 davfs2 挂载 webdav](https://blog.oopsky.top/post/a7b61f3fa1934555a3a519c34a61cd75/)
3. 现在可以使用各种批量重命名工具
   * Windows：可以用 [PowerToys](https://github.com/microsoft/PowerToys) 里的 PowerRename
   * Linux：可以写脚本遍历目录，通过 `rename` 或 `mv`、`sed` 等命令行工具实现批量重命名
