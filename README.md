# friendlyKeylogger
Small terminal program to visualize Planck keyboard input

Due to difficulties acsessing keyboard hooks on WSL, a client and server setup is needed. Where the client runs on windows and records all keypresses, which then sends it to the program running on ubuntu WSL

**Warning: big bodge**
Uses alot of system specifics, therefore it would need a bunch of changes to work for you. It specifically requires a windows machine with administrator rights, running wsl and an ortholinear 12x4 keyboard.

Python3 on clientside for the simple keyboard input, writing to file.
Coffescript node reading file with bash for the speed, drawing to terminal using <a href="https://github.com/chjj/blessed">blessed <3</a>

<img width="200%" height="200%" src="./screencap.png"/>

**TODO:**
- Divide into classes in seperate files
- Seperate dom element handling from functional code
- Real comments
- Make windows dynamically resize
- Hotkeys eight bars to be updated, not replaced
