.PHONY: s
default: s

node_modules: package.json
	npm i

#f: build.sh
#	npm run gen && for i in `ls source/_posts`;do mdfmt -w source/_posts/$i;done

g: node_modules
	npm run gen && hexo c && hexo g && hexo s

s: node_modules
	hexo c && hexo g && hexo s