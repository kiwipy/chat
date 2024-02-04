#!/bin/bash
#
# File for:    chat (Github version)
# Copyright:   William Andersson 2024
# Website:     https://github.com/william-andersson
# License:     GPL
#
#
# - Setup initial parent path for toolbox-chat
# - Add subdirectory path "chatroom"
#
if [ "$1" == "--help" ] || [ -z "$1" ] || [ -z "$2" ];then
	echo -e "Usage: $0 <OPTION> <PATH>"
	echo -e "Setup new chatroom for toolbox-chat\n"
	echo -e "Options:"
	echo -e "--init <PATH>\t\tSetup toolbox-chat."
	echo -e "\t\t\tRun this first time to setup parent directory."
	echo -e "--add <PATH>\t\tSetup new chatroom."
	exit 0
fi
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi
PATH=$2

if [ "$1" == "--init" ];then
	echo "Creating directory $PATH/default ..."
	/bin/mkdir -p $PATH/default
	/bin/chmod 777 $PATH/default
	echo "Creating file $PATH/default/WORDLIST ..."
	/bin/touch $PATH/default/WORDLIST
	/bin/chmod 644 $PATH/default/WORDLIST
	echo "Creating file $PATH/default/USER_LIST ..."
	/bin/touch $PATH/default/USER_LIST
	/bin/chmod 666 $PATH/default/USER_LIST
elif [ "$1" == "--add" ];then
	if [ -d "$PATH" ];then
		echo "$PATH already exists!"
		exit 2
	elif [ ! -d "${PATH%/*}/default" ];then
		echo "Invalid path!"
		exit 2
	else
		echo "Creating directory $PATH ..."
		/bin/mkdir $PATH
		/bin/chmod 777 $PATH
		echo "Creating file $PATH/WORDLIST ..."
		/bin/touch $PATH/WORDLIST
		/bin/chmod 644 $PATH/WORDLIST
		echo "Creating file $PATH/USER_LIST ..."
		/bin/touch $PATH/USER_LIST
		/bin/chmod 666 $PATH/USER_LIST
	fi
fi

echo "Done."
