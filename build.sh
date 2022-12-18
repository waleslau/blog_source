#!/bin/bash
# ./build.sh
curl -s -L https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz | tar xvzf - -C ./
export PATH="$(pwd)/pandoc-2.19.2/bin:$PATH"
npm i
hexo g
