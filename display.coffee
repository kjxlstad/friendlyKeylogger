# (1) Setup
fs = require 'fs'
blessed = require 'blessed'
{ exec } = require 'child_process'
os = require 'os'
require('dotenv').config()
log = process.env.WINPATH

screen = blessed.screen {smartCSR: true, dockBorders: true}
	
# Current keyboard specifics TODO: move to config file
planck =
	width: 12
	height: 4
	keymap: [ '', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'backspace',
		'tab', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'',
		'shift', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 'enter',
		'esc', 'ctrl_l', 'cmd', 'alt_l', '', 'space', 'space', '', 'left', 'down', 'up', 'right' ]


# (2) Helpers
window = (top, left, width, height, title) ->
	windowBorder top, left, width, height
	windowTitle top, left + 4, title
	
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
			fg: 'magenta'
	
keyBox = (x, y, w, h) ->
	return blessed.box
		top: y
		left: x
		width: w + 2
		height: h + 1
		border:
			type: 'line'
			fg: 'magenta'

# takes x, y coordinates in keymap grid, gets a blessed box customized for its location on screen
getKeyBox = (i, j) ->
	x = (keyWidth + 1) * i
	y = keyHeight * j + 1

	# Special cases for spacebar
	if i == 5 and j == 3
		b = keyBox x, y, keyWidth * 2 + 1, keyHeight
	else if i == 6 and j == 3
		return
	else
		b = keyBox x, y, keyWidth, keyHeight
	screen.append b
	return b

# Quit on esc, q or ctrl-c
screen.key ['escape', 'q', 'C-c'], (ch, key) ->
	process.exit 0

# (3) Blessed visual layout
# Header
text = 'friendly keylogger on #{os.hostname}'
screen.append blessed.text
	top: 0
	left: 1
	width: text.length
	height: 1
	content: text

# Time
text = 'logging since '

exec 'date +%H:%M', (err, stdout, stderr) ->
	text += stdout
	screen.append blessed.text
		top: 0
		right: 2
		width: text.legnth
		height: 1
		align: 'right'
		content: text
	screen.render()

# Planck
keyWidth = 4
keyHeight = 2
keys = (getKeyBox i % planck.width, Math.floor i / planck.width for i in [0 ... planck.height * planck.width])
windowTitle 1, 4, ' Planck '

# Hotkeys
window 1, 61, screen.width - (61 + 1), 19, ' Hotkeys '
	
# Stats
window 10, 0, 61, 10, ' Stats '

# (4) Updating
update = (key, dir) ->
	return if not planck.keymap.includes key
	pressed = keys[planck.keymap.indexOf key]
	if dir
		pressed.style.bg = 'red'
		
		# Remove sticky keys #TODO fix sending of keys
		setTimeout () ->
			update key, 0
		, 3000
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

# (5) Start
screen.render()
