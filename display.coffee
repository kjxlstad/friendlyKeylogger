fs = require('fs')
blessed = require('blessed')
{ exec } = require('child_process')

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

# Blessed boxes
screen = blessed.screen {smartCSR: true, dockBorders: true}

keyWidth = 9
keyHeight = 9

getBox = (i, j) ->
	x = (keyWidth + 1) * i + 5
	y = keyHeight * j + 1
	b = box x, y, keyWidth, keyHeight
	screen.append b
	return b

box = (x, y, w, h) ->
	return blessed.box
		top: y
		left: x
		width: w + 1
		height: h + 1
		border:
			type: 'line'

screen.append blessed.box
	top: 0
	left: 0
	width: 20
	height: 20
	content: 'test'
	border:
		type: 'line'

screen.render

keys = (getBox i % planck.width, Math.floor i / planck.width for i in [0 ... planck.height * planck.width])

# quit on escape, q, or ctrl-c
screen.key ['escape', 'q', 'C-c'], (ch, key) ->
	return process.exit 0

update = (key, dir) ->
	return if not planck.keymap.includes key
	pressed = keys[planck.keymap.indexOf key]
	if dir
		pressed.style.bg = 'white'
	else
		pressed.style.bg = 'none'
	screen.render
	return

a = 0
fs.watch log, (e, f) ->
	if a++ % 4 == 0 
		exec "tail -1 #{log}", (err, stdout, stderr) ->
			[key, dir] = stdout.split(' ')
			update key, parseInt dir
			return
	return

# screen.render
