fmt:
    just --fmt --unstable
    git add .justfile

gs:
    pnpm hexo generate
    pnpm hexo server -l

cgs:
    rm -f ./source/_posts/*.md
    cp -vf ../notes-obsidian/BLOG/*.md ./source/_posts/
    fd -e md -x sd 'created:' 'date:'
    pnpm hexo clean
    just gs

push:
    git remote | xargs -I _ git push _

done:
    git add .
    git commit -m "update"
    just push
