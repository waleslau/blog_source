crlf_format := if os_family() == "windows" { 'fd . -e md source/_posts/ -X sd "\n" "\r\n"' } else { "uname -sm" }

fmt:
    just --fmt --unstable
    git add .justfile
    fd . -e md source/_posts/ -X mdfmt -w
    git add source/_posts/*

# {{ crlf_format }} # emmm, do not need this, git will deal with it automatically
# git status -s

# gen contents from joplin
gen:
    curl http://127.0.0.1:41184 >/dev/null 2>&1
    pnpm mami
    just fmt

# clean then generate html
cgs:
    pnpm hexo clean
    pnpm hexo generate
    just s
# server
s:
    pnpm hexo g
    @# miniserve -v --index=index.html public
    @# cd public && python3 -m http.server --bind 127.0.0.1 4000
    pnpm hexo server -l

done:
    just fmt
    git add .
    git commit -m "update"
    #just push

push:
    git remote | xargs -I _ git push _
