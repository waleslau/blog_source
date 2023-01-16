#!/bin/bash

# init pandoc and mdfmt
if test -s /etc/passwd && test -s /etc/os-release; then
    echo "You are use Linux now."
    # install pandoc
    if $(test -s $(pwd)/pandoc-2.19.2/bin/pandoc) || hash pandoc 2>/dev/null; then
        echo 'already have pandoc here.'
    else
        echo -e "\e[36m install pandoc \e[0m"
        curl -s -L https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz | tar xvzf - -C ./
        # set $PATH
        export PATH="$(pwd)/pandoc-2.19.2/bin:$PATH"
    fi
    
    # install mdfmt
    if $(test -s $(pwd)/pandoc-2.19.2/bin/mdfmt) || hash mdfmt 2>/dev/null; then
        echo 'already have mdfmt here.'
    else
        echo -e "\e[36m install mdfmt \e[0m"
        mkdir $(pwd)/mdfmt && curl -s -L https://github.com/elliotxx/mdfmt/releases/download/v0.4.2/mdfmt_0.4.2_Linux_x86_64.tar.gz | tar xvzf - -C ./mdfmt/ && mv ./mdfmt/mdfmt ./pandoc-2.19.2/bin/ && rm -rf ./mdfmt
        # set $PATH
        export PATH="$(pwd)/pandoc-2.19.2/bin:$PATH"
    fi
else
    echo "You are use Windows now."
fi

# init nodejs-lts
if test -s /etc/passwd && test -s /etc/os-release && test ! -d $HOME/.nvm; then
    echo -e "\e[36m init nodejs-lts \e[0m"
    curl -o- https://cdn.jsdelivr.net/gh/nvm-sh/nvm/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
else
    echo "already have nvm here, or you are use Widows now."
fi

if hash pnpm 2>/dev/null; then
    echo 'already have pnpm here.'
else
    npm install -g pnpm
    pnpm install
fi

# gen

curl http://127.0.0.1:41184 >/dev/null 2>&1 && echo -e "\e[36m pnpm mami ... \e[0m" && pnpm mami

# mdfmt
echo -e "\e[36m do mdfmt ... \e[0m"
for i in $(ls source/_posts); do mdfmt -w source/_posts/$i; done

if test -s /etc/passwd && test -s /etc/os-release; then
    echo "You are use Linux now."
else
    echo -e "\e[36m Widows: LF --> CRLF \e[0m"
    for i in $(ls source/_posts); do sed -i 's/$/\r/g' source/_posts/$i; done
fi

# build blog
echo -e "\e[36m build blog \e[0m"
export TZ='Asia/Shanghai'
pnpm hexo clean
pnpm hexo generate

# 如果是在 github actions、cloudflare pages、vercel等平台部署，
# 把构建命令改成 /build.sh 即可
# 构建输出目录是 /public
