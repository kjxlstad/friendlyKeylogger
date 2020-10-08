require('dotenv').config()
const fs = require('fs')
const { exec } = require('child_process')
let Canvas = require('drawille')
const line = require('bresenham')
const blessed = require('blessed')
const log = process.env.WINPATH

const planck = {
	width: 12,
	height: 4,
	keymap: 
			[ '',      'q',      'w',   'e',     'r',   't',     'y',     'u',   'i',    'o',    'p',  'backspace',
			  'tab',   'a',      's',   'd',     'f',   'g',     'h',     'j',   'k',    'l',    ';',  '\'',
			  'shift', 'z',      'x',   'c',     'v',   'b',     'n',     'm',   ',',    '.',    '/',  'enter',
			  'esc',   'ctrl_l', 'cmd', 'alt_l', '',    'space', 'space', '',    'left', 'down', 'up', 'right'     ]
}

let keys = []

//var c = new Canvas()
//const keyHeight = (c.height - 8)/ (planck.height)
//const keyWidth = keyHeight * 1.15
//const keyWidth = Math.min(c.width / (planck.width + 1), c.height / (planck.height + 1))
//const keyHeight = keyWidth * 0.8

let screen = blessed.screen({smartCSR: true, dockBorders: true})
// Regular half window at current fontsize is 134 * 57


/*
var box = blessed.box({
	top: 'center',
	left: 'center',
	width: '50%',
	height: '50%',
	content: 'Test {bold}Tester{/bold}',
	border: {
		type: 'line'
	},
	style: {
		fg: 'white',
		hover: {
			bg: 'black'
		}
	}
})
*/


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

screen.render()

/*
function drawBox(x0, y0, x1, y1, filled) {
	if (filled) for (let i = y0; i < y1; i++) line(x0, i, x1, i, c.set.bind(c))
	else for (let i = y0; i < y1; i++) line(x0, i, x1, i, c.unset.bind(c))
	drawBorder()	
	process.stdout.write(c.frame())
}

function drawBorder() {
	// Vertical lines
	line(0, 4, planck.width * keyWidth, 4, c.set.bind(c))
	line(0, 4 + keyHeight * planck.height, planck.width * keyWidth, 4 + keyHeight * planck.height, c.set.bind(c))

	// Horizontal
	line(0, 4, 0, 4 + keyHeight * planck.height, c.set.bind(c))
	line(planck.width * keyWidth, 4, planck.width * keyWidth, 4 + keyHeight * planck.height, c.set.bind(c))
}

function getPos(i, j) {
	const x0 = keyWidth * i
	const x1 = keyWidth * (i + 1)
	const y0 = keyHeight * j + 4
	const y1 = keyHeight * (j + 1) + 4
	return [x0, y0, x1, y1]
}

function updateKey(i, j, filled) {
	const pos = getPos(i, j)
	drawBox(pos[0], pos[1], pos[2], pos[3], filled)
}

function update(key, dir) {
	const linIndex = planck.keymap.findIndex((e) => e == key)
	const y = Math.floor(linIndex / planck.width)
	const x = linIndex % planck.width
	updateKey(x, y, dir)
}
*/

let a = 0
fs.watch(log, (e, f) => {
	if (a++ % 4 === 0) {
		exec(`tail -1 ${log}`, (err, stdout, stderr) => {
			const [key, dir] = stdout.split(' ')
			//update(key, parseInt(dir))
		})
	}
})
