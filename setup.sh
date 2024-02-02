#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

read -p "Enter path for chatroom: " PATH
if [ -d "$PATH" ];then
	read -p "Path already exists, use anyway[y/n] " Q
	if [ "$Q" == "y" ];then
		chmod 777 $PATH
		touch $PATH/WORDLIST
		chmod 644 $PATH/WORDLIST
		touch $PATH/USER_LIST
		chmod 666 $PATH/USER_LIST
	else
		exit 2
	fi
else
	mkdir -p $PATH
	chmod 777 $PATH
	touch $PATH/WORDLIST
	chmod 644 $PATH/WORDLIST
	touch $PATH/USER_LIST
	chmod 666 $PATH/USER_LIST
fi

echo "Done."
