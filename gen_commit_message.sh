#!/bin/bash

# 关闭中文转码
git config core.quotepath false

# 设定生成的提交信息的存储位置
message_file=/tmp/blog_message_file
 
# 获取即将提交的更改文件列表
files=$(git diff --cached --name-status)

# 获取 note 仓库最新提交的 id
note_latest_commit=`cd /opt/sites/notes-obsidian && git pull &> /dev/null && git log --pretty=format:"%h" -n 1`

# 如果有更改文件，则将它们添加到提交消息中
if [ -n "$files" ]; then
  # 从提交消息文件中读取原始提交消息  
  # 将更改文件列表添加到提交消息中，包括操作类型
  echo -e "from commit $note_latest_commit in note repo\n" > "$message_file"
  echo -e "Changed files:" >> "$message_file"
  while read -r line; do
    status=$(echo "$line" | cut -d$'\t' -f1)
    file=$(echo "$line" | cut -d$'\t' -f2)
    if [ "$status" == "A" ]; then
      echo "  Added: $file" >> "$message_file"
    elif [ "$status" == "M" ]; then
      echo "  Modified: $file" >> "$message_file"
    elif [ "$status" == "D" ]; then
      echo "  Deleted: $file" >> "$message_file"
    fi
  done <<< "$files"
fi
