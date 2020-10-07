import http.client
from pynput import keyboard

client = http.client.HTTPConnection('localhost', 8888)

def post_request(client, data) :
	client.request('POST', '/process', data)

def clean_keycode(key) :
	key = str(key)
	return (key, key[4:])[key.startswith('Key')]

def on_press(key) :
	post_request(client, '{"' + clean_keycode(key) + '" : 1}') 	
	check_response()

def on_release(key) :
	post_request(client, '{"' + clean_keycode(key) + '" : 0}')
	check_response()

def check_response() :
	print(client.getresponse().read())

with keyboard.Listener(on_press=on_press, on_release=on_release) as listener :
	listener.join()
