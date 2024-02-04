#!/bin/bash
VERSION=1.3
#
# Terminal chat program. (setup NFS mount for LAN messages or use ssh)
# Copyright: William Andersson 2024
# Website: https://github.com/william-andersson
# License: GPL
#
if [ ! -f "$HOME/.toolbox-chat" ];then
	read -p "Set name: " ID
	read -p "Set server path: " SERVER
	if [ ! -d "$SERVER" ];then
		echo "Invalid server location!"
		exit 2
	elif [ -f "$SERVER/default/$ID" ];then
		echo "Username already exists!"
		exit 2
	else
		echo "ID=$ID" > $HOME/.toolbox-chat
		echo "PATH=$SERVER" >> $HOME/.toolbox-chat
		echo "$ID=0" >> $SERVER/default/USER_LIST
		touch $SERVER/default/$ID
		chmod 622 $SERVER/default/$ID
	fi	
fi

ID="$(grep -m 1 'ID=' $HOME/.toolbox-chat | sed 's/.*=//')"
SERVER="$(grep -m 1 'PATH=' $HOME/.toolbox-chat | sed 's/.*=//')"
ROOM="default"
WORDLIST=$(cat $SERVER/$ROOM/WORDLIST)

function abort() {
	# Ctrl-c SIGINT
	set_status
	reset
	exit 0
}
trap abort SIGINT

function change_room(){
	if [ ! -d "$SERVER/$1" ];then
		echo -e "\033[31m[$ID]: No such chatroom [$1]!\033[0m" >> $SERVER/$ROOM/$ID
		return
	else
		echo "" > $SERVER/$ROOM/$ID
		set_status
		ROOM=$1
		if [ ! $(grep $ID $SERVER/$ROOM/USER_LIST) ];then
			echo "$ID=1" >> $SERVER/$ROOM/USER_LIST
			touch $SERVER/$ROOM/$ID
			chmod 622 $SERVER/$ROOM/$ID
		fi
	fi
}

function set_status(){
	STATUS=$(grep $ID $SERVER/$ROOM/USER_LIST | sed 's/.*=//')
	if [ "$STATUS" == "0" ];then
		sed -i 's/'$ID=$STATUS'/'$ID=1'/' $SERVER/$ROOM/USER_LIST
	else
		sed -i 's/'$ID=$STATUS'/'$ID=0'/' $SERVER/$ROOM/USER_LIST
	fi
}

function send(){
	SAY="$1"
	if [ ! -z "$SAY" ];then
		for word in ${WORDLIST[@]};do
			if [[ "${SAY,,}" == *"${word,,}"* ]];then
				# check if string contains forbidden word
				# ${VAR,,} converts both strings to lower case
				echo -e "\033[31m[$ID]: No bad language!\033[0m" >> $SERVER/$ROOM/$ID
				main
			fi
		done
		CALL_NAME=$(echo $SAY | cut -d " " -f1)
		NAME=$(echo "${CALL_NAME:1}")
		MSG=$(echo $SAY | sed "s/^[^ ]* //")
		
		# Send message to user
		if [[ "$CALL_NAME" == *"@"* ]];then
				if [ -f "$SERVER/$ROOM/$NAME" ];then
					echo -e "\033[33m@[$NAME]\033[0m: $MSG" >> $SERVER/$ROOM/$ID
					echo -e "\033[32m[$ID]\033[0m: $MSG" >> $SERVER/$ROOM/$NAME
				else
					echo -e "\033[31m@[$NAME]: No such user! Try again using the resend (r) option.\033[0m" >> $SERVER/$ROOM/$ID
					echo $MSG > $HOME/.tmp-toolbox-chat
				fi
		else
		# Send message to all user
			for id in $(cat $SERVER/$ROOM/USER_LIST | sed 's/=.*//');do
				if [ "$id" == "$ID" ];then
					echo -e "\033[33m[$ID]\033[0m: $SAY" >> $SERVER/$ROOM/$ID
				else
					# Only send public messages to online users
					if [ "$(grep $id $SERVER/$ROOM/USER_LIST | sed 's/.*=//')" != "0" ];then
						echo -e "\033[97m[$ID]\033[0m: $SAY" >> $SERVER/$ROOM/$id
					fi
				fi
			done
		fi
	fi
	main
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
		cat $SERVER/$ROOM/$ID
		tput cup 21 0
		repeat 80 "_"
		read -t 5 -n 1 -p ">> " CMD
		echo ""
		if [ "$CMD" == "q" ];then #Quit
			set_status
			echo "" > $SERVER/$ROOM/$ID
			reset
			exit 0
			
		elif [ "$CMD" == "l" ];then #List rooms
			AVA_ROOMS=()
				for room in $(ls $SERVER);do
					AVA_ROOMS+=("[$room]")
				done
			echo -e "Chatrooms: ${AVA_ROOMS[@]}" >> $SERVER/$ROOM/$ID
		
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
			USERS=()
			for USER in $(cat $SERVER/$ROOM/USER_LIST | sed 's/=.*//');do
				if [ "$(grep $USER $SERVER/$ROOM/USER_LIST | sed 's/.*=//')" == "1" ];then
					USERS+=("\033[32m[$USER]\033[0m")
				else
					USERS+=("[$USER]")
				fi
			done
			echo -e "Users: ${USERS[@]}" >> $SERVER/$ROOM/$ID	
			
		elif [ "$CMD" == "h" ];then #Help
			echo -e "q (Quit)\t\tu (List users)\t\tl (List rooms)\
					\nc (Change room)\t\tw (Start message)\tr (Resend)\
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

set_status
main
