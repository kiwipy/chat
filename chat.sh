#!/bin/bash
#
# Application: chat (Github version)
# Copyright:   William Andersson 2024
# Website:     https://github.com/william-andersson
# License:     GPL
#
VERSION=2.0

if [ "$1" == "--help" ];then
	echo -e "Usage: $0 [OPTIONS]"
	echo -e "Options only available for root (admin)\n"
	echo -e "Options"
	echo -e "--admin <ROOM> <\"MESSAGE\">\tROOM = Chatroom name"
	echo -e "\t\t\t\tMESSAGE = Message to be sent"
	exit 0
fi

function abort() {
	# Ctrl-c SIGINT
	set_status
	reset
	exit 0
}
trap abort SIGINT

function change_room(){
	if [ ! -d "$SERVER/$1" ];then
		echo -e "\033[91m[$USER]: No such chatroom [$1]!\033[0m" >> $SERVER/$ROOM/$USER
		return
	else
		echo "" > $SERVER/$ROOM/$USER
		set_status
		ROOM=$1
		if [ ! $(grep $USER $SERVER/$ROOM/USER_LIST) ];then
			echo "$USER=1" >> $SERVER/$ROOM/USER_LIST
			touch $SERVER/$ROOM/$USER
			chmod 622 $SERVER/$ROOM/$USER
		fi
	fi
}

function set_status(){
	STATUS=$(grep $USER $SERVER/$ROOM/USER_LIST | sed 's/.*=//')
	if [ "$STATUS" == "0" ];then
		sed -i 's/'$USER=$STATUS'/'$USER=1'/' $SERVER/$ROOM/USER_LIST
	else
		sed -i 's/'$USER=$STATUS'/'$USER=0'/' $SERVER/$ROOM/USER_LIST
	fi
}

function send(){
	SAY="$1"
	if [ ! -z "$SAY" ];then
		for word in ${WORDLIST[@]};do
			if [[ "${SAY,,}" == *"${word,,}"* ]];then
				# check if string contains forbidden word
				# ${VAR,,} converts both strings to lower case
				echo -e "\033[91m[$USER]: No bad language!\033[0m" >> $SERVER/$ROOM/$USER
				return
			fi
		done
		CALL_NAME=$(echo $SAY | cut -d " " -f1)
		NAME=$(echo "${CALL_NAME:1}")
		MSG=$(echo $SAY | sed "s/^[^ ]* //")
		
		# Send message to user
		if [[ "$CALL_NAME" == *"@"* ]];then
				if [ -f "$SERVER/$ROOM/$NAME" ];then
					echo -e "\033[93m@[$NAME]\033[0m: $MSG" >> $SERVER/$ROOM/$USER
					echo -e "\033[92m[$USER]\033[0m: $MSG" >> $SERVER/$ROOM/$NAME
				else
					echo -e "\033[91m@[$NAME]: No such user! Try again using the resend (r) option.\033[0m" >> $SERVER/$ROOM/$USER
					echo $MSG > $HOME/.tmp-toolbox-chat
				fi
		else
		# Send message to all user
			for id in $(cat $SERVER/$ROOM/USER_LIST | sed 's/=.*//');do
				if [ "$id" == "$USER" ];then
					echo -e "\033[93m[$USER]\033[0m: $SAY" >> $SERVER/$ROOM/$USER
				else
					# Only send public messages to online users
					if [ "$(grep $id $SERVER/$ROOM/USER_LIST | sed 's/.*=//')" != "0" ];then
						if [ "$ID" == "admin" ];then
							echo -e "\033[94m[$ID]: $SAY\033[0m" >> $SERVER/$ROOM/$id
						else
							echo -e "\033[97m[$USER]\033[0m: $SAY" >> $SERVER/$ROOM/$id
						fi
					fi
				fi
			done
		fi
	fi
}

function repeat(){
	# print pattern x times
	# repeat INT "CHAR"
	c=$1
	while true;do
		echo -n "$2"
		((c-=1))
		if [ "$c" == "0" ];then
			break
		fi
	done
}

function header(){
	count="0"
	for i in $(cat $SERVER/$ROOM/USER_LIST);do
		((count+=1))
	done
	HEADER="Chatroom: $( echo $ROOM | sed 's:.*/::') | Users: $count"
	HEADER_LEN=${#HEADER}
	HEADER_SUB="$((76-HEADER_LEN))"
	PANNING="$((HEADER_SUB/2))"
	echo "$(repeat $PANNING '=')[ $HEADER ]$(repeat $PANNING '=')"
}

function main(){
	while true;do
		SAY=""
		clear
		header
		cat $SERVER/$ROOM/$USER
		tput cup 21 0
		repeat 80 "_"
		read -t 1 -n 1 -p ">> " CMD
		echo ""
		if [ "$CMD" == "q" ];then #Quit
			set_status
			echo "" > $SERVER/$ROOM/$USER
			reset
			exit 0
			
		elif [ "$CMD" == "l" ];then #List rooms
			ROOM_LIST=()
				for room in $(ls $SERVER);do
					ROOM_LIST+=("[$room]")
				done
			echo -e "Chatrooms: ${ROOM_LIST[@]}" >> $SERVER/$ROOM/$USER
		
		elif [ "$CMD" == "c" ];then #Change room
			read -p "Enter room: " SAY
			change_room "$SAY"
			
		elif [ "$CMD" == "w" ];then #Start message
			read -p "Say: " SAY
			send "$SAY"
			
		elif [ "$CMD" == "r" ];then #Resend
			read -p "To user: " SAY
			send "$SAY $(cat $HOME/.tmp-toolbox-chat)"
			
		elif [ "$CMD" == "u" ];then #List users	
			USER_LIST=()
			for user in $(cat $SERVER/$ROOM/USER_LIST | sed 's/=.*//');do
				if [ "$(grep $user $SERVER/$ROOM/USER_LIST | sed 's/.*=//')" == "1" ];then
					USER_LIST+=("\033[32m[$user]\033[0m")
				else
					USER_LIST+=("[$user]")
				fi
			done
			echo -e "Users: ${USER_LIST[@]}" >> $SERVER/$ROOM/$USER	
			
		elif [ "$CMD" == "h" ];then #Help
			echo -e "q (Quit)\t\tw (Start message)\t\tl (List rooms)\
					\nc (Change room)\t\tu (List users)\t\t\tr (Resend)\
					\nh (Help)"
			echo ""
			echo "Write to specific user:"
			echo "Start message with @USERNAME"
			echo "To resend failed message press (r) and only type @USERNAME"
			echo ""
			read -p "Paused, press enter to continue..."
		fi
	done
}

if [ "$1" == "--admin" ];then
	if [[ $EUID -ne 0 ]]; then
		echo "Only root can send messages as admin!"
		exit 1
	else
		ID="admin"
		SERVER="/srv/toolbox-chat"
		ROOM="$2"
		send "${@:3}"
		exit 0
	fi
fi

SERVER="/srv/toolbox-chat"
ROOM="default"
WORDLIST=$(cat $SERVER/$ROOM/WORDLIST)

if [ ! -f "$SERVER/$ROOM/$USER" ];then
	echo "$USER=0" >> $SERVER/$ROOM/USER_LIST
	touch $SERVER/$ROOM/$USER
	chmod 622 $SERVER/$ROOM/$USER
fi

if [ "$UID" != "$(stat -L -c "%u" $SERVER/$ROOM/$USER)" ];then
	echo "Username $USER is locked!"
	exit 1
fi

set_status
main
