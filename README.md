# Simple Terminal Instant Messanger
> [!IMPORTANT]
> This project will not recieve any further updates.<br>

### Let users on ssh server chat with each other! :smiley:<br>
![Screenshot](https://github.com/william-andersson/chat/blob/main/Screenshot2.png)

## Make it work

Install with **`sudo ./install.sh`** and then run **`sudo stim-setup --init`** to setup the application.<br>
Default location is /srv/stim and the default chatroom is "default".<br>


> [!NOTE]
> :blue_square: Only private messages are sent to offline users.<br>
> :blue_square: Ability to change chatrooms (setup beforehand with **`sudo stim-setup --add`**).<br>
> :blue_square: The WORDLIST file created can be populated with "forbidden" words separated with spaces.<br>

>[!TIP]
> :green_square: Ban user by changing owner of corresponding /srv/stim/default/username file to root.<br>
> :green_square: Send message to everyone as admin with **`sudo stim --admin <ROOM> <"MESSAGE">`**.<br>

## Server signup feature
> [!WARNING]
> This is most definitely a security risk!<br>
> Only use this on a virtual machine on your local network!

Navigate to the server folder and run **`sudo ./setup.sh`**<br>
#### HOW IT WORKS
>- This will create the user (signup), you'll have to set a password.<br>
>- This user has a special bashrc file that automatically executes new_account.sh so people logging in with
>signup@ip can create their own account.<br>
>- If the scipt is exited the session is logged out.<br>
>- When a user logs in, STIM is automatically started and if exited the session logs out.<br>
>- The IP is logged when account was created sucessfully and blocked for further signups.

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

