# Simple terminal chat application
![Screenshot](https://github.com/william-andersson/chat/blob/main/Screenshot.png)

## Make it work

Set this up on a ssh server for users to chat with each other :)<br>
Run **sudo toolbox-chat-setup --init** or **sudo ./setup.sh --init** to create the server.

- Color coded nicks.
- The WORDLIST file created can be populated with "forbidden" words separated with spaces

> [!NOTE]
> Only private messages are sent to offline users.<br>
> Ability to change chatrooms (setup beforehand with **sudo toolbox-chat-setup --add**).<br>

>[!NOTE]
> Default server location /srv/toolbox-chat.<br>
> Default chatroom "default"

>[!NOTE]
> Ban user by changing owner of corresponding /srv/toolbox-chat/default/username to root.

## Usage
Run toolbox-chat and press the following keys to...

* *w - to start typing a message*
* *u - to list all users (online users show up in green)*
* *l - to list available chatrooms*
* *c - change chatroom*
* *r - to resend message if wrong nickname was entered*
* *h - for help*
* *q - to quit*

All messages are sent to every user unless the message starts with @username<br>

## Limitations
> [!IMPORTANT]
> Only shorter messages work, return key = send
