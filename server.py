import json
from bottle import run, post, request, response

keymap = [['',      'q',      'w',   'e',    'r', 't',     'y',     'u', 'i',    'o',    'p',  'backspace'],
	      ['tab',   'a',      's',   'd',    'f', 'g',     'h',     'j', 'k',    'l',    ';',  '\''       ],   
		  ['shift', 'z',      'x',   'c',    'v', 'b',     'n',     'm', ',',    '.',    '/',  'enter'    ],   
          ['esc',   'ctrl_l', 'cmd', 'alt_l', '', 'space', 'space', '',  'left', 'down', 'up',  'right'   ]]   

heatmap = [[0 for i in range(12)] for i in range(4)]

# Returns a tuple with all indices where the key was found in keymap
def find_key_pos(key) :
	return [(ix, iy) for ix, row in enumerate(keymap) for iy, i in enumerate(row) if i == key]

#def update(key) :

#def decipher(data) :
	


@post('/process')
def my_process() :
	req_obj = json.loads(request.body.read())
	print(req_obj)	
	return 'All done'

run(host='localhost', port=8888, debug=True)
