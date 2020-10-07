#!/bin/bash
# Usage ./run.sh with windows folder as argument where the client will be created
# Eg. ./run.sh /user/name/documents

if [ $# -eq 0 ]; then
	echo "No folder path supplied!"
	exit;
fi

dir=/mnt/c"$1"/friendlyKeyloggerClient/

if [[ -d "$dir" ]]; then
	read -p "Folder $dir allready exists, do you want to overwrite it? y/n"
	case $yn in
		[Yy]* ) rm -r "$dir"; break;;
		[Nn]* ) exit;;
		* ) echo "Please answer yes or no"
	esac
fi

mkdir $dir
cp -r client "$dir"/client
	
log="$dir"log.log
echo WINPATH="$log" > .env
touch "$log"
