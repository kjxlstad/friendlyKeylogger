# friendlyKeylogger
Small terminal program to visualize Planck keyboard input

Due to difficulties acsessing keyboard hooks on WSL, a client and server setup is needed. Where the client runs on windows and records all keypresses, which then sends it to the program running on ubuntu WSL

Warning, janky botched code.
Python3 on clientside for the simple keyboard input, writing to file.
Node reading file with bash for the speed, drawing to terminal using blessed.

**Old gui, styling for later (ctrl and alt are being held for screencap)**
<img src="https://i.imgur.com/y27Uyhj.png"/>

**New gui, based on blessed**
<img width="200%" height="200%" src="https://i.imgur.com/HRficmj.png"/>
