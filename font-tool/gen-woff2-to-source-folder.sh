#!/bin/sh
# pipx install fonttools

# https://github.com/lxgw/LxgwMarkerGothic/releases
# https://www.fonts.net.cn/font-41767292968.html
TEXT1="热心市民L先生のBLOG"
TEXT2="首页归档分类标签关于友链其他HOMELinux常用软件列表"
TEXT_en="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
TEXT1_all_en="$TEXT_en$TEXT1"
TEXT2_all_en="$TEXT_en$TEXT2"

pyftsubset.exe --text=$TEXT1 --output-file='../source/css/woff2/JingNanJunJunTi.OnlyRequire.woff2' JingNanJunJunTi.ttf
# pyftsubset.exe --text=$TEXT1_all_en --output-file='../source/css/woff2/JingNanJunJunTi.OnlyRequire.woff2' JingNanJunJunTi.ttf
pyftsubset.exe --text=$TEXT2 --output-file='../source/css/woff2/LXGWMarkerGothic.OnlyRequire.woff2' LXGWMarkerGothic.ttf
# pyftsubset.exe --text=$TEXT2_all_en --output-file='../source/css/woff2/LXGWMarkerGothic.OnlyRequire.woff2' LXGWMarkerGothic.ttf
# pyftsubset.exe --text-file='characters_count.txt' fusion-pixel.otf --output-file='../source/css/woff2/fusion-pixel.OnlyRequire.woff2'
