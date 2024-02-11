#!/bin/bash
#
# Application: chat (Github version)
# Copyright:   William Andersson 2024
# Website:     https://github.com/william-andersson
# License:     GPL
#
VERSION=2.6

if [ "$1" == "--help" ];then
	echo -e "Usage: $0 [OPTIONS]"
	echo -e "Options only available for root (admin)\n"
	echo -e "Options"
	echo -e "--admin <ROOM> <\"MESSAGE\">\tROOM = Chatroom name"
	echo -e "\t\t\t\tMESSAGE = Message to be sent"
	exit 0
fi

function abort() {
	# Ctrl-c SIGINT function
	cp $SERVER/$ROOM/$USER $SERVER/$ROOM/log/$USER.$(date +%d-%m-%Y.%H:%M)
	echo "" > $SERVER/$ROOM/$USER
	set_status
	reset
	tput cnorm
	exit 0
}
trap abort SIGINT

function change_room(){
	if [ -z "$1" ] || [ ! -d "$SERVER/$1" ];then
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
	SENTENCE=()
	if [ ! -z "$SAY" ];then
		for word in $SAY;do
			if [ $(grep "$word" /usr/share/toolbox/emoji ) ];then
				# Add emoji if pattern match
				SENTENCE+=("$(grep $word /usr/share/toolbox/emoji | sed 's/.*=//')")
			else
				SENTENCE+=("$word")
			fi
		done
	
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
		MSG=$(echo "${SENTENCE[@]}" | sed "s/^[^ ]* //")
		 
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
					echo -e "\033[93m[$USER]\033[0m: "${SENTENCE[@]}"" >> $SERVER/$ROOM/$USER
				else
					# Only send public messages to online users
					if [ "$(grep $id $SERVER/$ROOM/USER_LIST | sed 's/.*=//')" != "0" ];then
						if [ "$ID" == "admin" ];then
							echo -e "\033[94m[$ID]: $SAY\033[0m" >> $SERVER/$ROOM/$id
						else
							echo -e "\033[97m[$USER]\033[0m: "${SENTENCE[@]}"" >> $SERVER/$ROOM/$id
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

function refresh(){
	tput cup 0 0
	HEIGHT=$(tput lines)
	WIDTH=$(tput cols)
	if [[ "$HEIGHT" -ne "$OLD_HEIGHT" ]] || [[ "$WIDTH" -ne "$OLD_WIDTH" ]];then
		tput clear
	fi
	count="0"
	for i in $(cat $SERVER/$ROOM/USER_LIST);do
		((count+=1))
	done
	HEADER="Chatroom: $( echo $ROOM | sed 's:.*/::') | Users: $count"
	HEADER_LEN=${#HEADER}
	HEADER_SUB="$((WIDTH-HEADER_LEN-4))"
	PANNING="$((HEADER_SUB/2))"
	tput ed
	echo -e "$(repeat $PANNING '=')[ $HEADER ]$(repeat $PANNING '=')"

	tail -n $((HEIGHT-5)) $SERVER/$ROOM/$USER

	tput cup $((HEIGHT-3)) 0
	repeat $WIDTH "_"
	OLD_HEIGHT=$HEIGHT
	OLD_WIDTH=$WIDTH
}

function main(){
	while true;do
		SAY=""
		refresh
		read -t 1 -n 1 -p ">> " CMD
		
		case $CMD in
			q)
				#Quit
				abort
				;;
			l)
				#List chatrooms
				ROOM_LIST=()
					for room in $(ls $SERVER);do
						ROOM_LIST+=("[$room]")
					done
				echo -e "Chatrooms: ${ROOM_LIST[@]}" >> $SERVER/$ROOM/$USER
				;;
			c)
				#Change chatroom
				tput cup $((HEIGHT-2)) 0
				read -p "Enter room: " SAY
				change_room "$SAY"
				;;
			w)
				#Write message
				tput cup $((HEIGHT-2)) 0
				read -p "Say: " SAY
				send "$SAY"
				;;
			r)
				#Resend
				tput cup $((HEIGHT-2)) 0
				read -p "To user: " SAY
				send "$SAY $(cat $HOME/.tmp-toolbox-chat)"
				;;
			u)
				#List users
				USER_LIST=()
				for user in $(cat $SERVER/$ROOM/USER_LIST | sed 's/=.*//');do
					if [ "$(grep $user $SERVER/$ROOM/USER_LIST | sed 's/.*=//')" == "1" ];then
						USER_LIST+=("\033[32m[$user]\033[0m")
					else
						USER_LIST+=("[$user]")
					fi
				done
				echo -e "Users: ${USER_LIST[@]}" >> $SERVER/$ROOM/$USER
				;;
			e)
				#List smileys
				tput cup $((HEIGHT-8)) 0
				tput ed
				repeat $WIDTH "_"
				count="0"
				for i in $(cat /usr/share/toolbox/emoji);do
					if [ "$count" == $((WIDTH/8)) ];then
						echo ""
						count="0"
					else
						echo -ne "$(grep $i /usr/share/toolbox/emoji | sed 's/.*=//') $(grep $i /usr/share/toolbox/emoji | sed 's/=.*//')\t"
						((count+=1))
					fi
				done
				echo -e "\n"
				read -p "Paused, press enter to continue..."
				;;
			h)
				#Help
				tput cup $((HEIGHT-13)) 0
				tput ed
				repeat $WIDTH "_"
				echo -e "\nVersion: $VERSION\n"
				echo -e "q (Quit)\t\tw (Start message)\t\tl (List rooms)\
						\nc (Change room)\t\tu (List users)\t\t\tr (Resend)\
						\ne (List emoji)\t\th (Help)"
				echo ""
				echo "Write to specific user:"
				echo "Start message with @USERNAME"
				echo "To resend failed message press (r) and only type @USERNAME"
				echo ""
				read -p "Paused, press enter to continue..."
				;;
			esac
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

clear
tput civis
set_status
main
