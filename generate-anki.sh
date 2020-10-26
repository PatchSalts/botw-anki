#!/bin/bash

[ -d "botw-master" ] || [ -f "master.zip" ] || curl -o master.zip https://codeload.github.com/leoetlino/botw/zip/master
[ -d "botw-master" ] || unzip master.zip
[ -f "master.zip" ] && rm master.zip
grep -P -r -h -o -I -f japanese.pattern botw-master/Message/Msg_JPja.product.sarc | sort -u > japanese.text
grep -P -x -f leading-chars.pattern japanese.text > leading-chars.text
comm -3 japanese.text leading-chars.text > non-leading-chars.text

echo > leading-chars-removed.text
for line in $(cat leading-chars.text); do
	until [[ $prompt == "y" ]] || [[ $prompt == "n" ]]; do
		echo ""
		echo "$line"
		read -n 1 -p "Is this furigana? [y/n]: " prompt
	done
	case $prompt in
		"y")
			echo "$line" | grep -P -o -f remove-leading.pattern >> leading-chars-removed.text
			;;
		"n")
			echo "$line" >> leading-chars-removed.text
			;;
	esac
	prompt=""
done
