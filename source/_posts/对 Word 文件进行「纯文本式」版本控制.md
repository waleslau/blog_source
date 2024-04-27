---
title: 对 Word 文件进行「纯文本式」版本控制
abbrlink: ff9138ea
updated: 2023-09-27 15:09:53
date: 2023-04-24 11:25:00
tags:
  - git
  - pandoc
---

> 今天是 4 月 24 日，我刚刚完成我的毕业论文撰写，今天上午提交的最后一版。刚才偶然间在少数派[^1]发现了这种方法，和我自己用的方法[^2]虽目的不同，但有异曲同工之妙，甚好甚好，在此记录一下吧。

## 准备工作

第一步，把 Git 与 Pandoc 安装好。

第二步，向你的 `~/.gitconfig` 添加下面内容：

```cfg
[diff "pandoc"]
  textconv=pandoc --to=markdown
  prompt = false
[alias]
  wdiff = diff --word-diff=color --unified=1
```

第三步，新建一个文件夹，在这个文件夹里初始化 Git 仓库（工作区）。

```shell
mkdir git-word-demo
cd git-word-demo
git init
```

第四步，在该文件夹里创建 `.gitattributes` 文件，并向其中写入如下内容：

```config
*.docx diff=pandoc
```

然后把该文件加入版本版本管理，并 commit 一下：

```shell
git add .gitattributes
git commit -m "init"
```

自此，准备工作就完成了

## 如何使用

首先新建一个 docx 格式的文件，打开它，随便打几个字，然后保存并关闭。

然后把该文件加入版本管理，并 commit 一下提交当前状态：

```shell
git add example.docx
git commit -m "add example.docx"
```

这就把 `example.docx` 纳入了版本管理。

来试一下修改这个文档，例如添加/删除某些字/行/段落等。保存并关闭文档。

执行 `git diff` 查看工作区中的变动，将可以看到终端中会显示文件的第几行发生了何种变化。

然后记录变化并 commit 之，参数 `-a` 的作用是自动记录所有已 `git add` 过的文件的变化

```shell
git commit -a -m "update"
```

然后可以进行新的修改。

## 总结

这种方法的优势是能把 docx 内排版的变化也一丝不苟地纳入版本控制，但我们无法通过版本控制工具观测到排版的变化，只能比较出文字内容的变化。另外，由于 docx 是二进制格式，和纯文本相比不够「清真」，可能会导致这个仓库的体积迅速变大（个人猜测，未验证），由于每次 diff 都需要 pandoc 转换一下，性能应该也有些损耗（至少我感觉是慢了不少）。

如果你和我有同样的顾虑，欢迎来看我的另一篇文章[^2]。

[^1]: [如何对 Word 文件进行「纯文本式」版本控制？](https://sspai.com/post/58507)
[^2]: [我是如何折腾我的毕业论文的 - 热心市民L先生のBLOG](https://blog.oopsky.top/post/67e81ff3/)
