crlf_format := if os_family() == "windows" { 'fd . -e md source/_posts/ -X sd "\n" "\r\n"' } else { "uname -sm" }

_fmt:
    just --fmt --unstable
    git add .justfile
    just --choose

# gen contents from joplin
gen:
    curl http://127.0.0.1:41184 >/dev/null 2>&1
    pnpm mami
    fd . -e md source/_posts/ -X mdfmt -w
    git add source/_posts/*
    # {{ crlf_format }} # emmm, do not need this, git will deal with it automatically
    # git status -s

# generate html
g:
    pnpm hexo generate

# clean then generate html
cg:
    pnpm hexo clean
    pnpm hexo generate

# server
s:
    miniserve -v --index=index.html public
    # cd public && python3 -m http.server 8080
    # pnpm hexo server

# examples
_python:
    #!/usr/bin/env python3
    print('Hello from python!')

_js:
    #!/usr/bin/env node
    console.log('Greetings from JavaScript!')

_bash:
    #!/usr/bin/env bash
    set -euxo pipefail # 兼容性配置 https://just.systems/man/zh/chapter_41.html
    hello='Yo'
    echo "$hello from Bash!"

_os:
    @[ {{ os() }} = 'windows' ] && echo 'Hello from Windows'
    @[ {{ os() }} = 'linux' ] && echo 'Hello from Linux'

# just _test xxx
_test arg:
    echo '{{ arg }}'
