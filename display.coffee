fs = require('fs')
screen = require('blessed')
{ exec } = require('child_process')
require('dotenv').config()
log = process.env.WINPATH

planck = {
	width: 12,
	height: 4,
	keymap: 
			[ '',      'q',      'w',   'e',     'r',   't',     'y',     'u',   'i',    'o',    'p',  'backspace',
			  'tab',   'a',      's',   'd',     'f',   'g',     'h',     'j',   'k',    'l',    ';',  '\'',
			  'shift', 'z',      'x',   'c',     'v',   'b',     'n',     'm',   ',',    '.',    '/',  'enter',
			  'esc',   'ctrl_l', 'cmd', 'alt_l', '',    'space', 'space', '',    'left', 'down', 'up', 'right'     ]


}


# quit on escape
screen.key ['escape', 'q', 'C-c'], (ch, key) ->
	return process.exit 0

a = 0
fs.watch log, (e, f) ->
	if a++ % 4 == 0 
		exec "tail -1 #{log}", (err, stdout, stderr) ->
			[key, dir] = stdout.split(' ')
			console.log key, dir
			return
	return
