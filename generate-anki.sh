#!/bin/bash

curl -o master.zip https://codeload.github.com/leoetlino/botw/zip/master
unzip master.zip
rm master.zip
grep -P -r -h -o -I -f japanese.pattern botw-master/Message/Msg_JPja.product.sarc

