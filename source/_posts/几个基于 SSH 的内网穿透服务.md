---
title: 几个基于 SSH 的内网穿透服务
abbrlink: 9821b2d1
date: 2023-05-05 07:19:58
updated: 2023-05-05 07:19:58
tags:
  - ssh
---

## 1. serveo.net

直接在命令行执行下面命令即可：

```bash
ssh serveo.net -R 80:localhost:4000
```

更多使用姿势敬请移步该项目[官网](https://serveo.net)查看。

## 2. srv.us

创建单个隧道

```bash
ssh srv.us -R 1:localhost:4000
```

同时创建多个隧道

```bash
ssh srv.us -R 1:localhost:4000 -R 2:192.168.0.1:80
```

## 3. localhost.run

临时使用：

```bash
ssh -R 80:localhost:4000 nokey@localhost.run
```

[注册账号](https://admin.localhost.run/)并上传公钥后可以直接使用 `localhost.run` 创建隧道，这样分配的子域名可以保持较久一些

## 4. sish

如果想自建类似的服务，可以看看这个。

Github：[https://github.com/antoniomika/sish](https://github.com/antoniomika/sish)
