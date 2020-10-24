#!/bin/bash

[ -d "botw-master" ] || [ -f "master.zip" ] || curl -o master.zip https://codeload.github.com/leoetlino/botw/zip/master
[ -d "botw-master" ] || unzip master.zip
[ -f "master.zip" ] && rm master.zip
grep -P -r -h -o -I -f japanese.pattern botw-master/Message/Msg_JPja.product.sarc > japanese.text

