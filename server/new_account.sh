abort() {
    exit 0
}
trap abort SIGINT

if grep -Fxq "$(echo $SSH_CLIENT | awk '{print $1}')" $HOME/has_account;then
    echo -e "\nThis IP already created an account!"
    echo "Contact admin if you wish to create another from the same IP."
    exit 1
else
    while true;do
        read -p "New username: " UNAME
        sudo /usr/sbin/useradd -m -s /bin/bash -g users $UNAME
        if [ $? == 0 ];then
            break
        fi
    done
    while true;do
        sudo /usr/bin/passwd $UNAME
        if [ $? == 0 ];then
            echo -e "\nNew user $UNAME created."
            echo "You can now login with $UNAME@$HOSTNAME"
            echo $SSH_CLIENT | awk '{print $1}' >> $HOME/has_account
            break
        fi
    done
fi
