#!/bin/bash
# ./build.sh
curl -s -L https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz | tar xvzf - -C ./
# mkdir $(pwd)/mdfmt && curl -s -L https://github.com/elliotxx/mdfmt/releases/download/v0.4.2/mdfmt_0.4.2_Linux_x86_64.tar.gz | tar xvzf - -C ./mdfmt/ && mv ./mdfmt/mdfmt ./pandoc-2.19.2/bin/
cat /etc/os-release
export PATH="$(pwd)/pandoc-2.19.2/bin:$PATH"
echo 'IF9fX19fX19fX19fX19fX19fX19fX19fXyAKPCBkb3dubG9hZCBwYW5kb2MgLi4uIE9LID4KIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAKICAgICAgICBcICAgXl9fXgogICAgICAgICBcICAob28pXF9fX19fX18KICAgICAgICAgICAgKF9fKVwgICAgICAgKVwvXAogICAgICAgICAgICAgICAgfHwtLS0tdyB8CiAgICAgICAgICAgICAgICB8fCAgICAgfHwK' | base64 -d
# for i in $(ls source/_posts); do mdfmt -w source/_posts/$i; done
# echo 'IF9fX19fX19fX19fX19fX19fX19fX18gCjwgZm9ybWF0IHRoZSAubWQgZmlsZS4gPgogLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAKICAgICAgICBcICAgXl9fXgogICAgICAgICBcICAob28pXF9fX19fX18KICAgICAgICAgICAgKF9fKVwgICAgICAgKVwvXAogICAgICAgICAgICAgICAgfHwtLS0tdyB8CiAgICAgICAgICAgICAgICB8fCAgICAgfHwK' | base64 -d
npm i
export TZ='Asia/Shanghai'
echo 'IF9fX19fX19fX19fX19fX19fX19fX19fX19fXyAKPCBleHBvcnQgVFo9J0FzaWEvU2hhbmdoYWknID4KIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAKICAgICAgICBcICAgXl9fXgogICAgICAgICBcICAob28pXF9fX19fX18KICAgICAgICAgICAgKF9fKVwgICAgICAgKVwvXAogICAgICAgICAgICAgICAgfHwtLS0tdyB8CiAgICAgICAgICAgICAgICB8fCAgICAgfHwK' | base64 -d
hexo g

# 如果是在本地预览，执行 npm run gen && npm run show 即可
# 或者 make / make s

# 如果是在 github actions、cloudflare pages、vercel等平台部署，
# 把构建命令改成 /build.sh 即可
# 构建输出目录是 /public
