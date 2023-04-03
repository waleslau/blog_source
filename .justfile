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
cg:
    pnpm hexo clean
    pnpm hexo generate

# server
s: cg
    miniserve -v --index=index.html public
    # cd public && python3 -m http.server 8080
    # pnpm hexo server

done:
    just fmt
    git add .
    git commit -m "update"

push:
    git remote | xargs -I _ git push _
