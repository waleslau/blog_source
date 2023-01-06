#!/bin/bash
echo -e "\tdo mdfmt -w posts.md ..."
for i in $(ls source/_posts); do mdfmt -w source/_posts/$i; done

if test -s /etc/passwd && test -s /etc/os-release; then
    echo -e "\tYou are use Linux now."
else
    echo -e "\tYou are use Widows now."
    echo -e "\tLF --> CRLF"
    for i in $(ls source/_posts); do sed -i 's/$/\r/g' source/_posts/$i; done
fi
