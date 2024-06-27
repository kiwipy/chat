#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Adding user [signup]"
useradd -m -s /bin/bash -U signup
if grep -q -E "^users:" /etc/group;then
    echo "Group users exists, skipping."
else
    groupadd -g 100 users
fi
echo "Set password for [signup]"
passwd signup
echo "signup ALL = (root) NOPASSWD: /usr/sbin/useradd, /usr/bin/passwd" >> /etc/sudoers
echo "\$HOME/new_account.sh" >> /home/signup/.bashrc
echo "logout" >> /home/signup/.bashrc
echo "/usr/local/bin/stim" >> /etc/skel/.bashrc
echo "logout" >> /etc/skel/.bashrc
install -C -m 555 -o signup -v new_account.sh /home/signup/new_account.sh
