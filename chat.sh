#!/bin/bash
VERSION=1.0
#
# Terminal chat program. (setup NFS mount for LAN messages)
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
	elif [ ! -f "$SERVER/USER_LIST" ];then
		echo "Invalid server location!"
		exit 2
	elif [ -f "$SERVER/$ID" ];then
		echo "Username already exists!"
		exit 2
	else
		echo "ID=$ID" > $HOME/.toolbox-chat
		echo "PATH=$SERVER" >> $HOME/.toolbox-chat
		echo "$ID=1" >> $SERVER/USER_LIST
		touch $SERVER/$ID
		chmod 622 $SERVER/$ID
	fi	
fi

ID="$(grep -m 1 'ID=' $HOME/.toolbox-chat | sed 's/.*=//')"
SERVER="$(grep -m 1 'PATH=' $HOME/.toolbox-chat | sed 's/.*=//')"
WORDLIST=$(cat $SERVER/WORDLIST)

function abort() {
### ctrl-c SIGINT
	set_status
	reset
	exit 0
}
trap abort SIGINT

function set_status(){
	STATUS=$(grep $ID $SERVER/USER_LIST | sed 's/.*=//')
	if [ "$STATUS" == "0" ];then
		sed -i 's/'$ID=$STATUS'/'$ID=1'/' $SERVER/USER_LIST
	else
		sed -i 's/'$ID=$STATUS'/'$ID=0'/' $SERVER/USER_LIST
	fi
}

function send(){
	SAY="$1"
	if [ ! -z "$SAY" ];then
		for word in ${WORDLIST[@]};do
			if [[ "${SAY,,}" == *"${word,,}"* ]];then
				# check if string contains forbidden word
				# ${VAR,,} converts both strings to lower case
				echo -e "\033[31m[$ID]: No bad language!\033[0m" >> $SERVER/$ID
				main
			fi
		done
		CALL_NAME=$(echo $SAY | cut -d " " -f1)
		NAME=$(echo "${CALL_NAME:1}")
		MSG=$(echo $SAY | sed "s/^[^ ]* //")
		if [[ "$CALL_NAME" == *"@"* ]];then
				if [ -f "$SERVER/$NAME" ];then
					echo -e "\033[33m@[$NAME]\033[0m: $MSG" >> $SERVER/$ID
					echo -e "\033[32m[$ID]\033[0m: $MSG" >> $SERVER/$NAME
				else
					echo -e "\033[31m@[$NAME]: No such user! Try again using the resend (r) option.\033[0m" >> $SERVER/$ID
					echo $MSG > $HOME/.tmp-toolbox-chat
				fi
		else
			for id in $(cat $SERVER/USER_LIST | sed 's/=.*//');do
				if [ "$id" == "$ID" ];then
					echo -e "\033[33m[$ID]\033[0m: $SAY" >> $SERVER/$ID
				else
					echo -e "\033[97m[$ID]\033[0m: $SAY" >> $SERVER/$id
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
	for i in $(cat $SERVER/USER_LIST);do
		((count+=1))
	done
	HEADER="Chatroom: $( echo $SERVER | sed 's:.*/::') | Users: $count"
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
		cat $SERVER/$ID
		tput cup 21 0
		repeat 80 "_"
		read -t 5 -n 1 -p ">> " CMD
		echo ""
		if [ "$CMD" == "q" ];then #Quit
			set_status
			reset
			exit 0
			
		elif [ "$CMD" == "c" ];then #Clear log
			echo "" > $SERVER/$ID
			
		elif [ "$CMD" == "w" ];then #Start message
			read -p "Say: " SAY
			send "$SAY"
			
		elif [ "$CMD" == "r" ];then #Resend
			read -p "To user: " SAY
			send "$SAY $(cat $HOME/.tmp-toolbox-chat)"
			
		elif [ "$CMD" == "l" ];then #List users	
			USERS=()
			for USER in $(cat $SERVER/USER_LIST | sed 's/=.*//');do
				if [ "$(grep $USER $SERVER/USER_LIST | sed 's/.*=//')" == "1" ];then
					USERS+=("\033[32m[$USER]\033[0m")
				else
					USERS+=("[$USER]")
				fi
			done
			echo -e "Users: ${USERS[@]}" >> $SERVER/$ID	
			
		elif [ "$CMD" == "h" ];then #Help
			echo -e "q (Quit)\t\tl (List users)\t\tc (Clear log)\
					\nw (Start message)\tr (Resend)\t\th (Help)"
			echo ""
			echo "Write to specific user:"
			echo "Start message with @USERNAME"
			echo "To resend faild message only type @USERNAME"
			echo ""
			read -p "Paused, press enter to continue..."
		fi
	done
}

set_status
main
