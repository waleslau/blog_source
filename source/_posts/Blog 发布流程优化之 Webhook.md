---
title: Blog 发布流程优化之 Webhook
abbrlink: a4327827
date: 2024-04-24 21:40:05
updated: 2024-04-30 22:19:52
tags:
  - code
---
## /etc/systemd/system/note_to_blog_api.service

```systemd
[Unit]
Description=Gunicorn instance
After=network.target

[Service]
User=api
Group=api
WorkingDirectory=/opt/sites/api/note_to_blog
ExecStart=gunicorn -b 192.168.252.166:29001 app_v3:app

[Install]
WantedBy=multi-user.target
```

## /opt/sites/api/note_to_blog/app_v3.py

```python
from flask import Flask, request, jsonify
import subprocess
import threading

app = Flask(__name__)

def run_in_background():
    proc = subprocess.run(['bash', 'script.sh'])

@app.route('/note_to_blog', methods=['POST'])
def run():
  # 鉴权
  auth_token = request.headers.get('Authorization')
  if auth_token != 'note_to_blog_secret':
    return 'Unauthorized\n', 401
  threading.Thread(target=run_in_background).start()
  return jsonify({'message': 'Script will run in background'})

if __name__ == '__main__':
  app.run(host='192.168.252.166', port=29001)
```

## 如何使用

启动守护进程后，给监听的端口发 POST 即可调用该 API

```bash
curl -X POST http://192.168.252.166:29001/note_to_blog -H 'Authorization: note_to_blog_secret'
```

然后在 Git 仓库设置里给 push 事件添加一个 webhook 即可实现提交代码后自动执行脚本更新 blog 文章，script.sh 就不再放出来了，里面就是 `hexo c`、`hexo g` 啥的。

---

用 Actions/Jenkins 之类的 CI/CD 工具或许更方便，但现在也够用了，小服务器资源有限，先用脚本处理吧😂
