#!/bin/sh
# pipx install fonttools

# https://github.com/lxgw/LxgwMarkerGothic/releases
# https://www.fonts.net.cn/font-41767292968.html
# https://github.com/TakWolf/fusion-pixel-font/releases

pyftsubset.exe --text-file='characters_count.txt' fusion-pixel.ttf --output-file='fusion-pixel.OnlyRequire.woff2'
pyftsubset.exe --text-file='characters_count.txt' JingNanJunJunTi.ttf --output-file='JingNanJunJunTi.OnlyRequire.woff2'
pyftsubset.exe --text-file='characters_count.txt' LXGWMarkerGothic.ttf --output-file='LXGWMarkerGothic.OnlyRequire.woff2'
