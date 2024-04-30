#!/bin/bash

# 关闭中文转码
git config core.quotepath false

# 设定生成的提交信息的存储位置
message_file=/tmp/blog_message_file
 
# 获取即将提交的更改文件列表
files=$(git diff --cached --name-status)

# 获取 note 仓库最新提交的 id
note_latest_commit=`cd /opt/sites/notes-obsidian && git pull &> /dev/null && git log --pretty=format:"%h" -n 1`

echo -e "from $note_latest_commit \n" > "$message_file"
git status --porcelain >> "$message_file" 
