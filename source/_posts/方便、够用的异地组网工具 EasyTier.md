---
title: 方便、够用的异地组网工具 EasyTier
abbrlink: cdbffbe9
date: 2025-04-07 20:24:37
updated: 2025-11-03 08:47:10
tags:
  - 内网穿透
  - 异地组网
---
2019 年至今，我长期使用过许多异地组网工具，ZeroTier、Tailscale、Happyn、VNT。。。

然而，这些工具在使用过程中都存在一些不顺心的地方，由于国内对跨网的 UDP 点对点通信 Qos 得很厉害，严重影响可用性；而且这些服务有的不支持自建中转或者自建很麻烦、有的没找到强制走中转的方式、有的官网经常被防火墙拦截。。。这就大大降低了上面提到的这些工具在我这里的使用体验。

前些时候发现了一个新工具，[EasyTier](https://github.com/EasyTier/EasyTier)，下载下来简单体验了一下后，我感觉这就是我要的组网工具：

- 配置简单，自建中转服务也很方便
- 默认 P2P 打洞，可在任意客户端随意选择强制走中转，中转协议支持 TCP！
- 可以很方便的在某个节点引入私网路由
- 支持 Windows、Android、Linux 等平台

另：这个软件的社区目前很活跃，除了 [官方的 GUI](https://easytier.cn/guide/download.html) 之外，也可以使用 [EasytierGame](https://github.com/EasyTier/EasytierGame) 或者 [Astral](https://github.com/ldoubil/astral/releases)
