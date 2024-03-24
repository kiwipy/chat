#!/bin/bash
#
# File for:    stim (Github version)
# Comment:     Simple Terminal Instant Messanger
# Copyright:   William Andersson 2024
# Website:     https://github.com/william-andersson
# License:     GPL
#
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

#DEPENDENCIES=("")

install -v -C -m 775 -o root main.sh /usr/bin/stim
install -v -C -m 775 -o root setup.sh /usr/bin/stim-setup
install -v -D -C -m 555 -o root emoji /usr/share/stim/emoji

#if [ ! -z "$DEPENDENCIES" ];then
#	/usr/bin/toolbox-depin ${DEPENDENCIES[@]}
#fi

echo "Done."
