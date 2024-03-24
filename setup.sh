#!/bin/bash
#
# File for:    stim (Github version)
# Comment:     Simple Terminal Instant Messanger
# Copyright:   William Andersson 2024
# Website:     https://github.com/william-andersson
# License:     GPL
#

if [ "$1" == "--help" ] || [ -z "$1" ];then
	echo -e "Usage: $0 <OPTION> [NAME]"
	echo -e "Setup new chatroom for STIM\n"
	echo -e "Options:"
	echo -e "--init\t\t\tSetup STIM in /srv/stim/default"
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
	echo "Creating directory /srv/stim/default ..."
	/bin/mkdir -p /srv/stim/default
	/bin/chmod 777 /srv/stim/default
	echo "Creating directory /srv/stim/default/log ..."
	/bin/mkdir -p /srv/stim/default/log
	/bin/chmod 777 /srv/stim/default/log
	echo "Creating file /srv/stim/WORDLIST ..."
	/bin/touch /srv/stim/default/WORDLIST
	/bin/chmod 644 /srv/stim/default/WORDLIST
	echo "Creating file /srv/stim/USER_LIST ..."
	/bin/touch /srv/stim/default/USER_LIST
	/bin/chmod 666 /srv/stim/default/USER_LIST
elif [ "$1" == "--add" ];then
	if [ -d "/srv/stim/$NAME" ];then
		echo "$NAME already exists!"
		exit 2
	else
		echo "Creating directory /srv/stim/$PATH ..."
		/bin/mkdir /srv/stim/$PATH
		/bin/chmod 777 /srv/stim/$PATH
		echo "Creating directory /srv/stim/$PATH/log ..."
		/bin/mkdir -p /srv/stim/$PATH/log
		/bin/chmod 777 /srv/stim/$PATH/log
		echo "Creating file /srv/stim/$PATH/WORDLIST ..."
		/bin/touch /srv/stim/$PATH/WORDLIST
		/bin/chmod 644 /srv/stim/$PATH/WORDLIST
		echo "Creating file /srv/stim/$PATH/USER_LIST ..."
		/bin/touch /srv/stim/$PATH/USER_LIST
		/bin/chmod 666 /srv/stim/$PATH/USER_LIST
	fi
fi

echo "Done."
