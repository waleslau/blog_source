#!/bin/bash
echo -e "\e[36m do mdfmt -w posts.md ... \e[0m"
for i in $(ls source/_posts); do mdfmt -w source/_posts/$i; done

if [ "$(uname -s)" = "Linux" ]; then
    echo "You are use Linux now."
else
    echo -e "\e[36m Widows: LF --> CRLF \e[0m"
    for i in $(ls source/_posts); do sed -i 's/$/\r/g' source/_posts/$i; done
fi
