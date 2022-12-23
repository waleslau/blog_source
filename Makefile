.PHONY: s
default: s

node_modules: package.json
	npm install

g: build.sh
	npm run gen
	for i in `ls source/_posts`;do mdfmt -w source/_posts/$i;done
	#cat .joplin-cache.json  | python3 -m json.tool > .joplin-cache.f.json
	cat .joplin-cache.json  | jq > .joplin-cache.f.json
	mv .joplin-cache.f.json .joplin-cache.json
	hexo c && hexo g && hexo s

s: node_modules
	hexo c && hexo g && hexo s
