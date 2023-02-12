lf_to_crlf := if os() == 'windows' { 'fd . -e md source/_posts/ -X sd "\n" "\r\n"' } else { '' }

@_default:
    just --fmt --unstable
    git add .justfile

# gen contents from joplin
gen:
    pnpm mami
    fd . -e md source/_posts/ -X mdfmt -w
    {{ lf_to_crlf }}
    git status

# clean then generate html
cg:
    pnpm hexo clean
    pnpm hexo generate

# server
s: cg
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
