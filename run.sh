#! usr/bin/env bash
# Usage ./run.sh directory whrere windows files will be places

dir="$1"/friendlyKeyloggerClient
if [ ! -d "$dir" ]; then
	mkdir $dir
	cp -r client "$dir"/client
	touch "$dir"/log.log
else
	echo Folder "$dir" already exists, aborting!
fi
