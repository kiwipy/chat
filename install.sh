#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

DEPENDENCIES=("")

install -v -C -m 775 -o root chat.sh /usr/bin/toolbox-chat
install -v -C -m 775 -o root setup.sh /usr/bin/toolbox-chat-setup

if [ ! -z "$DEPENDENCIES" ];then
	/usr/bin/toolbox-depin ${DEPENDENCIES[@]}
fi

echo "Done."
