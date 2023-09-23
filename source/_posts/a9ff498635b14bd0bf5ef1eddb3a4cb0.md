---
layout: post
title: 我的密码管理方案
abbrlink: a9ff498635b14bd0bf5ef1eddb3a4cb0
tags:
  - keepass
categories:
  - 笔记
date: 1695452662333
updated: 1695455851492
---
其实这篇文章我计划了好久了，大概去年的这个时候就已经在我的笔记库里创建了这个条目，但由于种种原因~~主要是懒~~一直处于草稿的状态。刚好前两天有个朋友问我是怎么管理我的密码的，我简单回复他之后，想起了在我笔记库里躺了两年的这个草稿。于是计划周末整理整理，发布到博客。下面是正文。

## 什么是 KeePass

KeePass 是一款免费的开源密码管理器，可帮助您以安全的方式管理您的密码。您可以将所有密码存储在一个数据库中，并使用主密钥锁定该数据库。因此，您只需记住一把主密钥即可解锁整个数据库。数据库文件使用目前已知的最好、最安全的加密算法（AES-256、ChaCha20 和 Twofish）进行加密。[^1]

下面是 KeePass 打动我的一些特点：

* 开源、免费
* 因为它是开源的，有很多开发者在各种平台为它开发了客户端
* 一个主密码即可解密整个数据库。如果想要更高的安全性也可以结合密钥文件使用。
* 密码数据库仅由一个文件组成，可以通过 WebDAV 等方式轻松地实现跨设备同步。
* 密码列表可以导出为各种格式，如 TXT、HTML、XML 和 CSV。

## 客户端推荐

下面列出我正在使用的客户端：

### KeePassXC[^3]

支持平台：Windows, macOS, and Linux

优点：功能全面，有浏览器插件

缺点：访问 WebDAV（但可以使用坚果云客户端弥补这一点）

### AuthPass[^4]

支持平台：Windows, macOS, Linux and Android

优点：界面简洁美观，支持直接访问 WebDAV、GoogleDrive 等平台上存储的密码数据库文件

缺点：功能略少（但也够用）

---

最初我在 Android 平台使用的客户端是 KeePassDX，功能强大堪比 PC 上的 KeePassXC，但可惜不支持直接访问 WebDAV，在我发现 AuthPass 后就弃用了它

如果上面没提到你现在使用的平台，可以去官网[^2]搜寻

## 如何使用

1. 首先，需要有一个 WebDAV 网盘，国内建议使用坚果云。
2. 在坚果云里创建一个目录，比如 KeePass。
3. 在电脑上安装坚果云的客户端，并把上一步创建的 KeePass 目录同步到本地某处。
4. 新建一个密码数据库，并把它保存到坚果云同步的目录内。
5. 现在可以在其他设备访问你的密码库文件。

[^1]: [https://keepass.info/](https://keepass.info/)


[^2]: [https://keepass.info/download.html](https://keepass.info/download.html)


[^3]: [https://keepassxc.org](https://keepassxc.org)


[^4]: [https://authpass.app/](https://authpass.app/)
