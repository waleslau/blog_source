fmt:
    just --fmt --unstable
    git add .justfile
    fd . -e md ./source/_posts -x prettier.cmd -w

pnpm:
    pnpm i

cg: pnpm
    pnpm hexo clean
    pnpm hexo generate

cgs: cg
    pnpm hexo server -l

push:
    git remote | xargs -I _ git push _

done:
    git add .
    #git commit -a -m "update: $(git diff --name-only)"
    git commit -a -m "update"
    git push

sync: pnpm
    rm -f ./source/_posts/*.md
    cp -f ../notes-obsidian/BLOG/*.md ./source/_posts/
    #fd . -e md ./source/_posts -x sd 'created:' 'date:'
    sed -i 's/created:/date:/' ./source/_posts/*.md
    git status | grep 'add' # 若无变动, 则退出执行
    pnpm hexo clean
    pnpm hexo generate
    python3 insert_abbrlink_to_obsidian.py
    git add source/_posts/*.md
    git add --all
    bash ./gen_commit_message.sh
    git commit -a -m "`cat /tmp/blog_message_file`" && git push
    cd ../notes-obsidian && git add BLOG/*.md && git commit -m 'sync to blog' | grep 'nothing to commit' || git push

