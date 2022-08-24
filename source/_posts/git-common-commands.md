---
title: GIT 常用命令
date: 2022-02-22 12:57:58
updated: 2022-02-22 12:57:58
mermaid: false
math: false
categories:
  - tech
tags:
  - git
---

```bash
# 切换分支
git switch <branch>
git checkout <branch>

# 撤销上次提交（本地）
git reset --soft HEAD~

# 重新提交（替换掉上次提交）
git commit --amend

# 撤销已经推送至远程的上次提交，会创建一个新commit
git revert HEAD

# 往前一次
git checkout HEAD～ OR git checkout HEAD^
# 往前二次
git checkout HEAD～2 OR git checkout HEAD^^
...
...

# 强制设置分支位置
git branch -f <branch_name> <md5sum>

# 将branch_B 合并到本分支，创建新提交
git merge <branch_B>

# 把某(几)次提交合并到当前分支
git git-cherry-pick <md5sum1>... ...

# 把branchB直到分叉之前的提交直接合并到branchA
git rebase <branchB> <branchB>

# 交互式排序分支
git rebase -i HEAD~4

# 取消暂存
git reset HEAD <file>...

# 打标签，默认标记当前HEAD
git tag v1.0 -m "my version 1.0"
# 推送标签到远程
git push origin v1.0
# 删除远程标签
git push origin --delete v1.0
# 删除本地标签
git tag -d v1.0

# 打印最近的 tag
git describe <ref>

# 拉取远程仓库内容（仅下载）
git fetch

# git fetch && git merge
git pull

# git fetch && git rebase
git pull --rebase

# 相比 merge ，rebase更干净，但可能会修改提交历史

# 设置远程追踪分支的两种方法
git checkout -b <local> origin/<remote>

git branch -u origin/<remote> <local>

# 任意推送
git push origin <local>:<remote>

# 任意拉取
git fetch origin <remote>:<local>

# 删除远程仓库中的分支
git push origin :<remote_branch>
git push origin --delete <remote_branch>

# 本地创建分支
git fetch origin :<NewBranch>
git checkout -b <NewBranch>

# 对上一次commit重新签名
git commit --amend --no-edit -n -S

# 对之前的commit直到 <md5sum> 都执行一次重新签名
git rebase --exec 'git commit --amend --no-edit -n -S' -i <md5sum>

# 让某个文件回到某个状态
git checkout <branch/commit> path/to/file
git checkout -- path/to/file # 最近一次

# 重置工作区
git reset --hard <branch/commit>
# 下面这三种效果相同，都是回到最近一次commit
git reset --hard
git reset --hard --
git reset --hard HEAD
```
