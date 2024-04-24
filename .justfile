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
    git commit -a -m "update"
    git push

sync: pnpm
    cd ../notes-obsidian && git pull
    rm -f ./source/_posts/*.md
    cp -vf ../notes-obsidian/BLOG/*.md ./source/_posts/
    #fd . -e md ./source/_posts -x sd 'created:' 'date:'
    sed -i 's/created:/date:/' ./source/_posts/*.md
    pnpm hexo clean
    pnpm hexo generate
    # insert abbrlink to obsidian
    python3 insert_abbrlink_to_obsidian.py
    just done

