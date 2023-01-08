.PHONY: g
default: g

node_modules: package.json
	pnpm install

g: node_modules
	pnpm gen
	./mdfmt.sh
	# cat .joplin-cache.json  | python3 -m json.tool > .joplin-cache.f.json
	# cat .joplin-cache.json  | jq > .joplin-cache.f.json && mv .joplin-cache.f.json .joplin-cache.json
	pnpm gg
gs: node_modules
	pnpm gen
	./mdfmt.sh
	# cat .joplin-cache.json  | python3 -m json.tool > .joplin-cache.f.json
	# cat .joplin-cache.json  | jq > .joplin-cache.f.json && mv .joplin-cache.f.json .joplin-cache.json
	pnpm gs