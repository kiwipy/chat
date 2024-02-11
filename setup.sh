#!/bin/bash
#
# File for:    chat (Github version)
# Copyright:   William Andersson 2024
# Website:     https://github.com/william-andersson
# License:     GPL
#

if [ "$1" == "--help" ] || [ -z "$1" ];then
	echo -e "Usage: $0 <OPTION> [NAME]"
	echo -e "Setup new chatroom for toolbox-chat\n"
	echo -e "Options:"
	echo -e "--init\t\t\tSetup toolbox-chat in /srv/toolbox-chat/default"
	echo -e "\t\t\tRun this first time to setup parent directory."
	echo -e "--add <NAME>\t\tNAME = name of new chatroom."
	exit 0
fi
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi
NAME=$2

if [ "$1" == "--init" ];then
	echo "Creating directory /srv/toolbox-chat/default ..."
	/bin/mkdir -p /srv/toolbox-chat/default
	/bin/chmod 777 /srv/toolbox-chat/default
	echo "Creating directory /srv/toolbox-chat/default/log ..."
	/bin/mkdir -p /srv/toolbox-chat/default/log
	/bin/chmod 777 /srv/toolbox-chat/default/log
	echo "Creating file /srv/toolbox-chat/WORDLIST ..."
	/bin/touch /srv/toolbox-chat/default/WORDLIST
	/bin/chmod 644 /srv/toolbox-chat/default/WORDLIST
	echo "Creating file /srv/toolbox-chat/USER_LIST ..."
	/bin/touch /srv/toolbox-chat/default/USER_LIST
	/bin/chmod 666 /srv/toolbox-chat/default/USER_LIST
elif [ "$1" == "--add" ];then
	if [ -d "/srv/toolbox-chat/$NAME" ];then
		echo "$NAME already exists!"
		exit 2
	else
		echo "Creating directory /srv/toolbox-chat/$PATH ..."
		/bin/mkdir /srv/toolbox-chat/$PATH
		/bin/chmod 777 /srv/toolbox-chat/$PATH
		echo "Creating file /srv/toolbox-chat/$PATH/WORDLIST ..."
		/bin/touch /srv/toolbox-chat/$PATH/WORDLIST
		/bin/chmod 644 /srv/toolbox-chat/$PATH/WORDLIST
		echo "Creating file /srv/toolbox-chat/$PATH/USER_LIST ..."
		/bin/touch /srv/toolbox-chat/$PATH/USER_LIST
		/bin/chmod 666 /srv/toolbox-chat/$PATH/USER_LIST
	fi
fi

echo "Done."
