require('dotenv').config()
const fs = require('fs')
const { exec } = require('child_process')
const log = process.env.WINPATH

let a = 0
fs.watch(log, (e, f) => {
	if (a++ % 4 === 0) {
		exec(`tail -1 ${log}`, (err, stdout, stderr) => {
			console.log(stdout)
		})
	}
})
