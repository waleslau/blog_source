#!/bin/bash

# init pandoc and mdfmt
if [ "$(uname -s)" = "Linux" ]; then

	mkdir -p $HOME/.local/bin
	export PATH="$HOME/.local/bin:$PATH"
	tmp_dir=$(mktemp -d)

	echo "You are use Linux now."
	# install pandoc
	if $(test -s $HOME/.local/bin/pandoc) || hash pandoc 2>/dev/null; then
		echo 'already have pandoc here.'
	else
		echo -e "\e[36m install pandoc \e[0m"
		curl -s -L https://hub.gitmirror.com/github.com//jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz | tar xvzf - -C $tmp_dir
		mv $tmp_dir/pandoc-2.19.2/bin/pandoc $HOME/.local/bin/
	fi

	# install mdfmt
	if $(test -s $HOME/.local/bin/mdfmt) || hash mdfmt 2>/dev/null; then
		echo 'already have mdfmt here.'
	else
		echo -e "\e[36m install mdfmt \e[0m"
		mkdir $tmp_dir/mdfmt && curl -s -L https://hub.gitmirror.com/github.com/elliotxx/mdfmt/releases/download/v1.0.0/mdfmt_Linux_x86_64.tar.gz | tar xvzf - -C $tmp_dir/mdfmt/ && mv $tmp_dir/mdfmt/mdfmt $HOME/.local/bin/
	fi
	rm -rf $tmp_dir
else
	echo "You are use Windows now."
fi

# init nodejs-lts
#if [ "$(uname -s)" = "Linux" ] && test ! -d $HOME/.n; then
if [ "$(uname -s)" = "Linux" ]; then
	echo -e "\e[36m init nodejs-lts \e[0m"
	export N_PREFIX=$HOME/.n
	export PATH="$HOME/.n/bin:$PATH"
	bash <(curl -L https://raw.gitmirror.com/tj/n/master/bin/n) lts
fi

if hash node &>/dev/null; then
	echo "already have nodejs here."
fi

if hash pnpm 2>/dev/null; then
	echo 'already have pnpm here.'
else
	npm install -g pnpm
fi

pnpm install --no-frozen-lockfile

# gen

curl http://127.0.0.1:41184 >/dev/null 2>&1 && echo -e "\e[36m pnpm mami ... \e[0m" && pnpm mami

mdfmt() {
	echo -e "\e[36m do mdfmt ... \e[0m"
	for i in $(ls source/_posts); do mdfmt -w source/_posts/$i; done

	if [ "$(uname -s)" = "Linux" ]; then
		echo "You are use Linux now."
	else
		echo -e "\e[36m Widows: LF --> CRLF \e[0m"
		for i in $(ls source/_posts); do sed -i 's/$/\r/g' source/_posts/$i; done
	fi
}

# build blog
echo -e "\e[36m build blog \e[0m"
export TZ='Asia/Shanghai'
pnpm hexo clean
pnpm hexo generate

# 如果是在 github actions、cloudflare pages、vercel等平台部署，
# 把构建命令改成 /build.sh 即可
# 构建输出目录是 /public
