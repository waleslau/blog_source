fmt:
    just --fmt --unstable
    git add .justfile

cgs:
    pnpm hexo clean
    pnpm hexo generate
    pnpm hexo server -l

sync:
    rm -f ./source/_posts/*.md
    cp -vf ../notes-obsidian/BLOG/*.md ./source/_posts/
    fd -e md -x sd 'created:' 'date:'
    pnpm hexo generate

push:
    git remote | xargs -I _ git push _

done:
    just sync
    git add .
    git commit -m "update"
    just push
