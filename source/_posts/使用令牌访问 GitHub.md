---
title: 使用令牌访问 GitHub
tags:
  - github
abbrlink: 545a5fc3
updated: 2021-08-14 08:24:00
date: 2021-08-14 08:24:00
---

从 2021 年 8 月 13 日开始，GitHub 将在对 Git 操作进行身份验证时不再接受帐户密码，并将要求使用基于令牌（token）的身份验证，例如个人访问令牌。当然你也可以选择使用 SSH 密钥。

要创建一个令牌，首先需要打开 [Personal access tokens](https://github.com/settings/tokens) ，点击 **Generate new token** ，接着为此令牌设置备注、过期时间并勾选适当的权限，最后点击 **Generate token** 生成令牌。

然后就可以使用 `https://<TOKEN>@github.com/<user_name>/<repo_name>.git` 操作仓库了。
