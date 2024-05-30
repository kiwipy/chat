# Simple Terminal Instant Messanger
### Let users on ssh server chat with each other! :smiley:<br>
![Screenshot](https://github.com/william-andersson/chat/blob/main/Screenshot2.png)

## Make it work

Install with **`sudo ./install.sh`** and then run **`sudo stim-setup --init`** to create the server.<br>
Default server location is /srv/stim and the default chatroom is "default".<br>


> [!NOTE]
> :blue_square: Only private messages are sent to offline users.<br>
> :blue_square: Ability to change chatrooms (setup beforehand with **`sudo stim-setup --add`**).<br>
> :blue_square: The WORDLIST file created can be populated with "forbidden" words separated with spaces.<br>

>[!TIP]
> :green_square: Ban user by changing owner of corresponding /srv/stim/default/username file to root.<br>
> :green_square: Send message to everyone as admin with **`sudo stim --admin <ROOM> <"MESSAGE">`**.<br>

## Usage
Run **`stim`** and press the following keys to...

> *w - start typing a message*<br>
> *u - list all users (online users show up in green)*<br>
> *l - list available chatrooms*<br>
> *c - change chatroom*<br>
> *r - resend message if wrong nickname was entered*<br>
> *e - list emojis*<br>
> *h - for help*<br>
> *q - quit*<br>

All messages are sent to every user unless the message starts with @username<br>

## Classic MSN emoji set
Almost all the original* MSN/ICQ emojis!
![Image](https://github.com/william-andersson/chat/blob/main/Emoji.png)
> \*Not the original design only the selection.<br>
> Provided by GNOME Characters [Gnome Characters App](https://apps.gnome.org/en-GB/Characters/) Copyright 2014-2018 Daiki Ueno

## Limitations

Only shorter messages work, return key = send

## TODO

> - [x] Adapt to window size<br>
> - [x] Rename to STIM (Simple Terminal Instant Messanger)<br>
> - [ ] Maybe add support for multiline message<br>
> - [ ] Maybe add a chatbot<br>
> - [ ] Ssh server signup solution
