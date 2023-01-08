#!/bin/bash
echo -e "\e[36m do mdfmt -w posts.md ... \e[0m"
for i in $(ls source/_posts); do mdfmt -w source/_posts/$i; done

if test -s /etc/passwd && test -s /etc/os-release; then
    echo -e "\e[36m You are use Linux now. \e[0m"
else
    echo -e "\e[36m You are use Widows now. \e[0m"
    echo -e "\e[36m LF --> CRLF"
    for i in $(ls source/_posts); do sed -i 's/$/\r/g' source/_posts/$i; done
fi
