const fs = require('fs')
const { exec } = require('child_process')
const blessed = require('blessed')

require('dotenv').config()
const log = process.env.WINPATH

// Current keyboard specifics TODO move to config file
const planck = {
	width: 12,
	height: 4,
	keymap: 
			[ '',      'q',      'w',   'e',     'r',   't',     'y',     'u',   'i',    'o',    'p',  'backspace',
			  'tab',   'a',      's',   'd',     'f',   'g',     'h',     'j',   'k',    'l',    ';',  '\'',
			  'shift', 'z',      'x',   'c',     'v',   'b',     'n',     'm',   ',',    '.',    '/',  'enter',
			  'esc',   'ctrl_l', 'cmd', 'alt_l', '',    'space', 'space', '',    'left', 'down', 'up', 'right'     ]
}

// Array of all blessed boxes
let keys = []

// Main blessed object, dimensionality 134 x 57 chars at horizontally split fullscreen terminal
let screen = blessed.screen({smartCSR: true, dockBorders: true})

// TODO calculate on the go, now based on 134 * 57 matrix
const keyWidth = 10
const keyHeight = 4

for (let j = 0; j < 4; j++) {
	for (let i = 0; i < 12; i++) {
		const x = keyWidth * (i + 0.5) 
		const y = keyHeight * (j + 0.25)
		let key = blessed.box({
			top: y,
			left: x,
			width: keyWidth + 1,
			height: keyHeight + 1,
			border: {
				type: 'line'
			},
			style: {
				fg: 'white'
			}
		})
		keys.push(key)
		screen.append(key)
	}
}

// Quit on Escape, q, or Control-c
screen.key(['escape', 'q', 'C-c'], (ch, key) => {
	return process.exit(0)
})

let a = 0
fs.watch(log, (e, f) => {
	if (a++ % 4 === 0) {
		exec(`tail -1 ${log}`, (err, stdout, stderr) => {
			const [key, dir] = stdout.split(' ')
			//update(key, parseInt(dir))
		})
	}
})

screen.render()
