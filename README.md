# Simple terminal chat application
- Run toolbox-chat-setup or ./setup.sh to create a "server" or new "chatroom".
- Share the server directory via NFS for LAN use.<br>
  **or set it up on a ssh server!**
- Color coded nicks.
- The file WORDLIST created can be populated with "forbidden" words separated with spaces
- Run toolbox-chat, create a nickname and enjoy!

## Usage
Just press the following key

- w - to start typing a message
- l - to list all users (online users show up in green)
- c - change chatroom
- r - to resend message if wrong nickname was entered
- h - for help
- q - to quit

All messages are sent to every user unless the message starts with @username<br>

## Limitations

- Only shorter messages work, return key = send

## Updates

- Only private messages are sent to offline users.
- Ability to change chatrooms (setup beforehand with toolbox-chat-setup)
