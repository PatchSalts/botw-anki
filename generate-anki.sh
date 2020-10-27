#!/bin/bash

# Download the BotW resource files, extract them, delete the archive.
[ -d "botw-master" ] || [ -f "master.zip" ] || curl -o master.zip https://codeload.github.com/leoetlino/botw/zip/master
[ -d "botw-master" ] || unzip master.zip
[ -f "master.zip" ] && rm master.zip

# Generate a text file containing all Japanese phrases in the resources.
grep -P -r -h -o -I -f jp.pattern botw-master/Message/Msg_JPja.product.sarc | sort -u > jp.text

# Generate a text file containing all Japanese phrases that have the format [kana/punct][kanji][anything].
grep -P -x -f jp-wlead.pattern jp.text > jp-wlead.text

# Generate a text file containing all Japanese phrase that DO NOT have the format [kana/punct][kanji][anything].
comm -3 jp.text jp-wlead.text > jp-nolead.text

# Prompt the user for each phrase with leading characters on whether or not said leading characters are furigana.
echo > jp-xlead.text
counter=1
for line in $(cat jp-wlead.text); do
	until [[ $prompt == "y" ]] || [[ $prompt == "n" ]]; do
		echo ""
		echo "$line"
		read -n 1 -p "($counter) Is this furigana? [y/n]: " prompt
	done
	case $prompt in
		"y")
			echo "$line" | grep -P -o -f jp-xlead.pattern >> jp-xlead.text
			;;
		"n")
			echo "$line" >> jp-xlead.text
			;;
	esac
	prompt=""
	let "counter+=1"
done

# Next: join jp-xlead.text and jp-nolead.text into the final list of all phrases to run through mecab.
