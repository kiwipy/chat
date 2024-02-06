# Simple terminal chat application
### Let users on ssh server chat with each other! :smiley:<br>
![Screenshot](https://github.com/william-andersson/chat/blob/main/Screenshot2.png)

## Make it work

Run **sudo toolbox-chat-setup --init** or **sudo ./setup.sh --init** to create the server.<br>
Default server location is /srv/toolbox-chat and the default chatroom is "default".<br>


> [!NOTE]
> :blue_square: Only private messages are sent to offline users.<br>
> :blue_square: Ability to change chatrooms (setup beforehand with **sudo toolbox-chat-setup --add**).<br>
> :blue_square: The WORDLIST file created can be populated with "forbidden" words separated with spaces.<br>

>[!TIP]
> :green_square: Ban user by changing owner of corresponding /srv/toolbox-chat/default/username file to root.<br>
> :green_square: Send message to everyone as admin with **sudo toolbox-chat --admin \<ROOM\> \<"MESSAGE"\>**.<br>

## Usage
Run toolbox-chat and press the following keys to...

> *w - start typing a message*<br>
> *u - list all users (online users show up in green)*<br>
> *l - list available chatrooms*<br>
> *c - change chatroom*<br>
> *r - resend message if wrong nickname was entered*<br>
> *h - for help*<br>
> *q - quit*<br>

All messages are sent to every user unless the message starts with @username<br>

## Limitations

Only shorter messages work, return key = send

## TODO

- [x] Adapt to window size<br>
- [ ] Maybe add support for multiline message<br>
- [ ] Ssh server signup feature
