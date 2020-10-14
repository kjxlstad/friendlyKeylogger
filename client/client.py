from pynput import keyboard
import os

log = '../log.log'

def write_to_file(data) :
	with open(log, 'w') as f:
		f.write(data)
	f.close()

def clean_keycode(key) :
	key = str(key)
	return (key[1:len(key)-1], key[4:])[key.startswith('Key')]#[1:len(key)-1]

def on_press(key) : write_to_file(clean_keycode(key) + ' 1')

def on_release(key) : write_to_file(clean_keycode(key) + ' 0')

# Clear file
open(log, 'w').close()

with keyboard.Listener(on_press=on_press, on_release=on_release) as listener :
	listener.join()
