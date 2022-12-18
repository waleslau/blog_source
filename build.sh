#!/bin/bash
# ./build.sh
curl -s -L https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz | tar xvzf - -C ./
export PATH="$(pwd)/pandoc-2.19.2/bin:$PATH"
npm i
hexo g

# 如果是在本地预览，执行 npm run gen && npm run show 即可

# 如果是在 github actions、cloudflare pages、vercel等平台部署，
# 把构建命令改成 /build.sh 即可
# 构建输出目录是 /public
