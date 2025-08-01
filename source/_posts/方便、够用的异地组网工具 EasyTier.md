---
title: 方便、够用的异地组网工具 EasyTier
abbrlink: cdbffbe9
date: 2025-04-07 20:24:37
updated: 2025-05-01 06:02:39
tags:
  - 内网穿透
  - 异地组网
---

2019 年至今，我长期使用过许多异地组网工具，ZeroTier、Tailscale、Happyn。。。

然而，这些工具在使用过程中都存在一些不顺心的地方，由于国内对跨网的 UDP 点对点通信 Qos 得很厉害，严重影响可用性；而且这些服务有的不支持自建中转或者自建很麻烦、有的没找到强制走中转的方式、有的官网经常被防火墙拦截。。。这就大大降低了上面提到的这些工具在我这里的使用体验。

前些时候发现了一个新工具，[EasyTier](https://github.com/EasyTier/EasyTier)，下载下来简单体验了一下后，我感觉这就是我要的组网工具：

- 配置简单，自建中转服务也很方便
- 默认 P2P 打洞，可在任意客户端随意选择强制走中转
- 可以很方便的在某个节点引入私网路由
- 支持 Windows、Android、Linux 等平台

另：目前官方的 Wihndows 平台 GUI 还有一些问题，建议使用 [基于 easytier 的简易游戏联机启动器](https://github.com/EasyTier/EasytierGame)

---

哦，还有一个叫 [VNT](https://rustvnt.com/) 的组网工具忘提了，但目前 EasyTier 在我这儿挺好用的就没去深入体验，故不再多说（看介绍的功能是蛮可以的，主要是 VNT 目前的用户界面不太合我口味 hhhh），感兴趣的话可以试试。
