require('dotenv').config()
const fs = require('fs')
const { exec } = require('child_process')
var Canvas = require('drawille')
const line = require('bresenham')

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

var c = new Canvas()
const keyWidth = Math.min(c.width / (planck.width + 1), c.height / (planck.height + 1))
const keyHeight = keyWidth * 0.8

function drawBox(x0, y0, x1, y1, filled) {
	if (filled) for (let j = y0; j < y1; j += 1) line(x0, j, x1, j, c.set.bind(c))
	else for (let j = y0; j < y1; j += 1) line(x0, j, x1, j, c.unset.bind(c))
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

let a = 0
fs.watch(log, (e, f) => {
	if (a++ % 4 === 0) {
		exec(`tail -1 ${log}`, (err, stdout, stderr) => {
			const [key, dir] = stdout.split(' ')
			update(key, parseInt(dir))
		})
	}
})
