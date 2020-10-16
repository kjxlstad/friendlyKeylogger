#!/bin/bash
# Usage ./run.sh with windows folder as argument where the client will be created
# Eg. ./run.sh /user/name/documents

if [ $# -eq 0 ]; then
	echo "No folder path supplied!"
	exit;
fi

dir=/mnt/c"$1"/friendlyKeyloggerClient

if [[ -d "$dir" ]]; then
	echo ""
	echo "Folder $dir allready exists, do you want to overwrite it?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) rm -r "$dir"; mkdir $dir; cp -r client "$dir"/; break;;
			No ) break;;
		esac
	done
fi
	
log="$dir"/log.log
echo WINPATH="$log" > .env
touch "$log"

echo ""
echo "Run client as windows admin now?"
select yn in "Yes" "No"; do
	case $yn in
		Yes ) cd "$dir"/client; cmd.exe /c runElevatedClient.bat; break;;
		No ) break;;
	esac
done

echo ""
echo "Run display host in this window?"
select yn in "Yes" "No"; do
	case $yn in
		Yes ) cd; cd friendlyKeylogger; coffee -c display.coffee; node display.js; break;;
		No ) exit;;
	esac
done
