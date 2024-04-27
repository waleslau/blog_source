fmt:
    just --fmt --unstable
    git add .justfile
    fd . -e md ./source/_posts -x prettier.cmd -w

pnpm:
    pnpm i

cgs: pnpm
    pnpm hexo clean
    pnpm hexo generate
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
    git status | grep 'modified:' # 若无变动, 则退出执行
    cd ../notes-obsidian && git log --pretty=format:"%h" -n 1 > /tmp/note_latest_hash
    echo "https://git.oopsky.top/waleslau/notes-obsidian/commit/`cat /tmp/note_latest_hash`" > /tmp/note_latest_url 
    pnpm hexo clean
    pnpm hexo generate
    python3 insert_abbrlink_to_obsidian.py
    git add source/_posts/*.md
    git commit -m "from commit `cat /tmp/note_latest_hash` in note repo" && git push
    cd ../notes-obsidian && git add BLOG/*.md && git commit -m 'sync to blog' | grep 'nothing to commit' || git push

