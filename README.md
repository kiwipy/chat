# Simple terminal chat application

Set this up on a ssh server for users to chat with each other :)<br>
Run **sudo toolbox-chat-setup --init** or **sudo ./setup.sh --init** to create the server.

- Color coded nicks.
- The WORDLIST file created can be populated with "forbidden" words separated with spaces
- Run toolbox-chat and enjoy!

## Usage
Just press the following key

* *w - to start typing a message* *
* *u - to list all users (online users show up in green)* *
* *l - to list available chatrooms* *
* *c - change chatroom* *
* *r - to resend message if wrong nickname was entered* *
* *h - for help* *
* *q - to quit* *

All messages are sent to every user unless the message starts with @username<br>

## Limitations
- Only shorter messages work, return key = send

> [!NOTE]
> Only private messages are sent to offline users.<br>
> Ability to change chatrooms (setup beforehand with **sudo toolbox-chat-setup --add**)
