import http.client
from pynput import keyboard

client = http.client.HTTPConnection('localhost', 8888)

def post_request(client, data) :
	client.request('POST', '/process', data)

def clean_keycode(key) :
	key = str(key)
	return (key, key[4:])[key.startswith('Key')][1:len(key)-1]

def on_press(key) :
	post_request(client, '{"%s" : 1}' % (clean_keycode(key))) 	
	check_response()

def on_release(key) :
	post_request(client, '{"%s" : 0}' % (clean_keycode(key)))
	check_response()

def check_response() :
	m = client.getresponse().read()
	if len(m) < 20 : print('All good') # lol
	else : print(m)

with keyboard.Listener(on_press=on_press, on_release=on_release) as listener :
	listener.join()
