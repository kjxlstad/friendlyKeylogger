require('dotenv').config()
//const term = require('terminal-kit').terminal
const fs = require('fs')
const { exec } = require('child_process')
var Canvas = require('drawille')
const line = require('bresenham')

const log = process.env.WINPATH

const planck = {
	width: 12,
	height: 4
}

var c = new Canvas()
var keySize = Math.min(c.width / (planck.width + 1), c.height / (planck.height + 1))

function drawBox(x0, y0, x1, y1) {
	line(x0, y0, x1, y0, c.set.bind(c)) // top
	line(x0, y0, x0, y1, c.set.bind(c)) // left
	line(x1, y0, x1, y1, c.set.bind(c)) // right
	line(x0, y1, x1, y1, c.set.bind(c)) // bottom
}

function draw() {
	c.clear()
	for (let j = 0; j < planck.height; j++) {
		for (let i = 0; i < planck.width; i++) {
			const x0 = keySize * i
			const x1 = keySize * (i + 1)
			const y0 = keySize * j + 4
			const y1 = keySize * (j + 1) + 4
			drawBox(x0, y0, x1, y1)
		}
	}
	process.stdout.write(c.frame())
}

draw()

/*
term.reset()
term.fullscreen()
let w = term.width
let h = term.height
term.red(w + "x" + h)

term.table( [
				[ 'Rot',   'Q',    'W',   'E',   'R',   'T',     'Y',     'U',   'I',    'O',    'P',  'Backspace' ],
				[ 'Tab',   'A',    'S',   'D',   'F',   'G',     'H',     'J',   'K',    'L',    ';',  '\''        ],
				[ 'Shift', 'Z',    'X',   'C',   'V',   'B',     'N',     'M',   ',',    '.',    '/',  'Enter'     ],
				[ 'Esc',   'Ctrl', 'CMD', 'Alt', 'FUp', 'Space', 'Space', 'FDn', 'Left', 'Down', 'Up', 'Right'     ]
			] , {
				hasBorder: true,
				borderchars: 'lightRounded',
				borderAttr: {color: 'red'},
				width: 100
	}
)
*/



let a = 0
fs.watch(log, (e, f) => {
	if (a++ % 4 === 0) {
		exec(`tail -1 ${log}`, (err, stdout, stderr) => {
			console.log(stdout)
			//term.red(stdout)
			//term.down(1)
			//term.left(3)
		})
	}
})
