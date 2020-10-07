import http.client
from pynput import keyboard

client = http.client.HTTPConnection('localhost', 8888)

def post_request(client, data) :
	client.request('POST', '/process', data)

def on_press(key) :
	#post_request(client, '{"{0}" : 1}'.format(key))
	post_request(client, '{"' + str(key) + '" : 1}') 
	#post_request(client, '{"test" : 1}')	
	check_response()

def on_release(key) :
	#post_request(client, '{"{0}" : 0'.format(key))
	post_request(client, '{"' + str(key) + '" : 0}')
	#post_request(client, '{"test" : 0}')
	check_response()

def check_response() :
	print(client.getresponse().read())

with keyboard.Listener(on_press=on_press, on_release=on_release) as listener :
	listener.join()
