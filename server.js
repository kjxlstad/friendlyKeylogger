const fs = require('fs')
const exec = require('child_process').exec
const log = '/mnt/c/users/jonathan/documents/friendlyKeylogger/log.log'

fs.watch(log, (e, f) => {
	exec(`tail -1 ${log} > ${log}`, (err, stdout, stderr) => {
		console.log(stdout)
	})
}
