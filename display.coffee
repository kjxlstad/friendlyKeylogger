# (1) Setup
fs = require 'fs'
blessed = require 'blessed'
{ exec } = require 'child_process'
os = require 'os'
require('dotenv').config()
log = process.env.WINPATH

# Current keyboard specifics TODO: move to config file
planck = 
	width: 12
	height: 4
	keymap: [ '',      'q',      'w',   'e',     'r',   't',     'y',     'u',   'i',    'o',    'p',  'backspace',
		'tab',   'a',      's',   'd',     'f',   'g',     'h',     'j',   'k',    'l',    ';',  '\'',
		'shift', 'z',      'x',   'c',     'v',   'b',     'n',     'm',   ',',    '.',    '/',  'enter',
		'esc',   'ctrl_l', 'cmd', 'alt_l', '',    'space', 'space', '',    'left', 'down', 'up', 'right'     ]

# (2) Blessed visual layout
screen = blessed.screen {smartCSR: true, dockBorders: true}

# Header
text = "friendly keylogger on #{os.hostname}"
screen.append blessed.text
	top: 0
	left: 1
	width: text.length
	height: 1
	content: text

# Time
screen.append blessed.text
	top: 0
	right: 1
	width: 9
	height: 1
	align: 'right'
	content: '23:16:45'

# Planck
keyWidth = 3
keyHeight = 2

# takes x, y coordinates in keymap grid, gets a blessed box customized for its location on screen
getBox = (i, j) ->
	x = (keyWidth + 1) * i
	y = keyHeight * j + 1
	b = box x, y, keyWidth, keyHeight
	screen.append b
	return b

box = (x, y, w, h) ->
	return blessed.box
		top: y
		left: x
		width: w + 2
		height: h + 1
		border:
			type: 'line'

keys = (getBox i % planck.width, Math.floor i / planck.width for i in [0 ... planck.height * planck.width])

window = (top, left, width, height, title) ->
	windowBorder top, left, width, height
	windowTitle top, left + 3, title
	
windowTitle = (top, left, title) ->
	screen.append blessed.text
		top: top
		left: left
		width: title.length
		height: 1
		content: title

windowBorder = (top, left, width, height) ->
	screen.append blessed.text
		top: top
		left: left
		width: width
		height: height
		border:
			type: 'line'
		

windowTitle 1, 3, ' Planck '

# Hotkeys
window 1, 50, screen.width - (50 + 1), 19, ' Hotkeys '
	
# Stats
window 10, 0, 49, 10, ' Stats '

# 3 Updating
update = (key, dir) ->
	return if not planck.keymap.includes key
	pressed = keys[planck.keymap.indexOf key]
	if dir
		pressed.style.bg = 'white'
	else
		pressed.style.bg = 'none'
	screen.render()
	return

a = 0
fs.watch log, (e, f) ->
	if a++ % 4 == 0 
		exec "tail -1 #{log}", (err, stdout, stderr) ->
			[key, dir] = stdout.split(' ')
			update key, parseInt dir
			return
	return

screen.render()

# 4 Helpers
# Quit on esc, q or ctrl-c
screen.key ['escape', 'q', 'C-c'], (ch, key) ->
	process.exit 0