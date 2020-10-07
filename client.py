import http.client
from pynput import keyboard

client = http.client.HTTPConnection('localhost', 8888)

def post_request(client, data) :
	cient.request('POST', '/process', data)

def on_press(key) :
	print(key)
	
def on_release(key) :
	print(key)




with keyboard.Listener(on_press=on_press, on_release=on_release) as listener :
	listener.join()

#doc = c.getresponse().read()
#print(doc)
