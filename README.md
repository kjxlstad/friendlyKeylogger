# friendlyKeylogger
Small terminal program to visualize Planck keyboard input

Due to difficulties acsessing keyboard hooks on WSL, a client and server setup is needed. Where the client runs on windows and records all keypresses, which then sends it to the program running on ubuntu WSL

Warning, janky botched code.
Python3 on clientside for the simple keyboard input, writing to file.
Node reading file with bash for the speed.

<img src="https://i.imgur.com/rOXukia.png"/>
