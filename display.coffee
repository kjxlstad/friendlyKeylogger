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
	keymap: [
		'',      'q',      'w',   'e',    'r', 't',     'y',     'u', 'i',    'o',    'p',  'backspace',
		'tab',   'a',      's',   'd',    'f', 'g',     'h',     'j', 'k',    'l',    ';',  '\'',
		'shift', 'z',      'x',   'c',    'v', 'b',     'n',     'm', ',',    '.',    '/',  'enter',
		'esc',   'ctrl_l', 'cmd', 'alt_l', '', 'space', 'space', '',  'left', 'down', 'up', 'right'
	]

keylog = {}

# (2) Helpers
# Text with all used options
fullText = (top, left, right, width, content, color = 'white') ->
	blessed.text
		left: left
		right: right
		top: top
		width: width
		height: 1
		content: content
		fg: color

# Most common left aligned text
leftText = (top, left, content, color = 'white') -> fullText top, left, null, content.length, content, color

# Once used right aligned text
rightText = (top, right, content) -> fullText top, null, right, content.length, content

# Title text with extra padding
titleText = (top, left, content) -> leftText top, left + 4, " #{content} "

# Box with all used fields
box = (top, left, width, height, color = 'red') ->
	blessed.box
		top: top
		left: left
		width: width
		height: height
		border:
			type: 'line'
			fg: color

# Boxes for drawing keyboard
keyBox = (x, y, w, h) ->
	box y, x, w + 2, h + 1
		
# Regular window
createWindow = (top, left, width, height, title) ->
	screen.append box top, left, width, height
	screen.append titleText top, left, title

# Statistic name and value
statistic = (name, stat, i) ->
	[
		(leftText 12 + i, 5,                name, 'magenta'),
		(fullText 12 + i, 5 + name.length, null, 30, stat, 'white')
	]

# Hotkey bar and according text
hotkeyBar = (key, w, n, i) ->
	[
		(fullText 3 + 2 * i, 63, null, 3, key),
	  	(box 2 + 2 * i, 67, w, 3, 'magenta'),
	  	(leftText 3 + 2 * i, 69, n.toString())
	]

# Used to grab top 8 keys in keylog	
getKeysWithHighestValues = (o, n) ->
	keys = Object.keys o
	keys.sort (a, b) ->
		return o[b] - o[a]
	return keys.slice 0, n

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
screen.append leftText 0, 1, "friendly keylogger on #{os.hostname}"

# Time
exec 'date +%H:%M', (err, stdout, stderr) ->
	screen.append rightText 0, 0, "logging since #{stdout}"
	screen.render()

# Planck
keyWidth = 4
keyHeight = 2
keys = (getKeyBox i % planck.width, Math.floor i / planck.width for i in [0 ... planck.height * planck.width])
screen.append titleText 1, 0, 'Planck'

# Hotkeys
hotkeyBars = []
createWindow 1, 61, screen.width - 61, 23, 'Hotkeys'

# Stats
stats = {}
createWindow 10, 0, 61, 10, 'Stats'

createWindow 20, 0, 61, 4, 'Yank my doodle'

progressBar = (top, left, width, value) ->
	blessed.ProgressBar
		top: top
		left: left
		width: width
		height: 1
		filled: value
		bg: 'red'
		fg: 'black'

screen.append progressBar 21, 1, 59, 50

stats['OS'] = statistic 'OS: ', 'Ubuntu 16.04.02', 0
stats['Kernel'] = statistic 'Kernel: ', os.release(), 1
stats['Uptimes'] = statistic 'Uptime: ', ' ', 2

cpu = os.cpus()[0]['model']
cputext = "#{cpu.slice 0, 5} #{cpu.slice 18, 25} (#{os.cpus().length}) #{cpu.slice 30, 39}"
stats['CPU'] = statistic 'CPU: ', cputext, 3


stats['Memory'] = statistic 'Memory: ', ' ', 4
stats['Keystrokes'] = statistic 'Keystrokes: ', '0', 5

for key of stats
	for elem in stats[key]
		screen.append elem

updateStats = () ->
	# Uptime
	uptimes = {}
	uptimeSeconds = os.uptime()
	uptimes['Days'] = uptimeSeconds / (60)**2 / 24
	uptimes['Hours'] = (uptimeSeconds / 60**2) % 24
	uptimes['Minutes'] = (uptimeSeconds / 60) % 60

	for unit of uptimes
		uptimes[unit] = Math.floor uptimes[unit]

	stats['Uptimes'][1].setContent "#{uptimes['Days']} days, #{uptimes['Hours']} hours, #{uptimes['Minutes']} mins"
	
	# Memory
	total = os.totalmem()
	usage = {}
	usage['Used'] =  (total - os.freemem()) / 1024**2
	usage['Total'] = total / 1024**2
	usage['Percentage'] = usage['Used'] * 100 / usage['Total']

	for key of usage
		usage[key] = Math.floor usage[key]

	stats['Memory'][1].setContent "#{usage['Used']} MiB / #{usage['Total']} MiB #{usage['Percentage']}%"
	
	# Total keystrokes
	s = 0
	for key of keylog
		s += keylog[key]
	stats['Keystrokes'][1].setContent s.toString()

updateStats()

# Peepo
peepoFrame = 0
currentPeepo = blessed.ANSIImage
	top: 12
	left: 43

screen.append currentPeepo

peepoUpdate = () -> currentPeepo.setImage "peepo/frame#{peepoFrame++ % 6}.gif"
	

# (4) Updating
update = (key, dir) ->
	return if not planck.keymap.includes key
	pressed = keys[planck.keymap.indexOf key]
	if dir
		# Update live image
		pressed.style.bg = 'red'
		
		# Update peepo
		peepoUpdate()
	
		# Update log
		if key in Object.keys keylog
			keylog[key]++
		else
			keylog[key] = 1
		
		updateHotkeys()
		
		# Update statistics
		updateStats()
				
		# Remove sticky keys #TODO fix sending of keys
		setTimeout () ->
			update key, 0
		, 3000
	else
		# Update live image
		pressed.style.bg = 'none'
	screen.render()
	return


updateHotkeys = () ->
	# Remove all previous graphbars from screen
	for bar in hotkeyBars
		for blessedObject in bar
			screen.remove blessedObject

	# Clear storage of bars
	hotkeyBars = []
	
	# Get most used keys
	hotkeys = getKeysWithHighestValues keylog, 10
		
	# Settings
	maxWidth = 65
	minWidth = 6
	maxValue = keylog[hotkeys[0]]
	
	# For every key : keypress pairs, create a hotkeyBar element and append to storage
	i = 0
	for key in hotkeys
		w = minWidth + Math.floor keylog[key] * (maxWidth - minWidth) / maxValue
		bar = hotkeyBar key, w, keylog[key], i++
		
		# Store bars i array
		hotkeyBars.push bar
		
		# append screen objects
		for blessedObject in bar
			screen.append blessedObject

# On logfile update, read new line and call update with key and direction
a = 0
fs.watch log, (e, f) ->
	if a++ % 4 == 0
		exec "tail -1 #{log}", (err, stdout, stderr) ->
			[key, dir] = stdout.split(' ')
			update key, parseInt dir

# (5) Start
screen.render()
