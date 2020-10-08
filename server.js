require('dotenv').config()
//const term = require('terminal-kit').terminal
const fs = require('fs')
const { exec } = require('child_process')
var Canvas = require('drawille')
const line = require('bresenham')

const log = process.env.WINPATH

const planck = {
	width: 12,
	height: 4,
	keymap: 
			[ '',    'q',      'w',   'e',     'r',   't',     'y',     'u',   'i',    'o',    'p',  'backspace',
			'tab',   'a',      's',   'd',     'f',   'g',     'h',     'j',   'k',    'l',    ';',  '\'',
			'shift', 'z',      'x',   'c',     'v',   'b',     'n',     'm',   ',',    '.',    '/',  'enter',
			'esc',   'ctrl_l', 'cmd', 'alt_l', '',    'space', 'space', '',    'left', 'down', 'up', 'right'     ]
}

var c = new Canvas()
var keyWidth = Math.min(c.width / (planck.width + 1), c.height / (planck.height + 1))
var keyHeight = keyWidth * 0.8

function drawBox(x0, y0, x1, y1, filled) {
	console.clear()
	if (filled) {
		for (let j = y0; j < y1; j++) {
			line(x0, j, x1, j, c.set.bind(c))
		}
	} else {
		line(x0, y0, x1, y0, c.set.bind(c)) // top
		line(x0, y0, x0, y1, c.set.bind(c)) // left
		line(x1, y0, x1, y1, c.set.bind(c)) // right
		line(x0, y1, x1, y1, c.set.bind(c)) // bottom
	}
	process.stdout.write(c.frame())
}

function drawGrid() {
	c.clear()
	for (let j = 0; j < planck.height; j++) {
		for (let i = 0; i < planck.width; i++) {
			const pos = getPos(i, j)
			drawBox(pos[0], pos[1], pos[2], pos[3], false)
		}
	}
	process.stdout.write(c.frame())
}

function getPos(i, j) {
	const x0 = parseInt(keyWidth * i)
	const x1 = parseInt(keyWidth * (i + 1))
	const y0 = parseInt(keyHeight * j + 4)
	const y1 = parseInt(keyHeight * (j + 1) + 4)
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

drawGrid()
