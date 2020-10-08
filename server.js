const fs = require('fs')
const { exec } = require('child_process')
const blessed = require('blessed')

require('dotenv').config()
const log = process.env.WINPATH

// TODO add styling and track stats since boot

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
const keyWidth = 9
const keyHeight = 4

for (let j = 0; j < 4; j++) {
	for (let i = 0; i < 12; i++) {
		const x = (keyWidth + 1) * i + 5
		const y = keyHeight * j + 1
		
		// Create and style box objects, one for each key
		let key = blessed.box({
			top: y,
			left: x,
			width: keyWidth + 1,
			height: keyHeight + 1,
			border: {
				type: 'bg',
				bg: 'white',
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

function update(key, dir) {
	if (!planck.keymap.includes(key)) return
	let pressed = keys[planck.keymap.indexOf(key)]
	if (dir) {
		pressed.style.bg = 'white'
		pressed.border.bg = 'white'
	} else {
		pressed.style.bg = 'none'
		pressed.border.bg = 'none'
	}
	screen.render()
}

let a = 0
fs.watch(log, (e, f) => {
	if (a++ % 4 === 0) {
		exec(`tail -1 ${log}`, (err, stdout, stderr) => {
			const [key, dir] = stdout.split(' ')
			update(key, parseInt(dir))
		})
	}
})

screen.render()
