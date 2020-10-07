import json

from bottle import run, post, request, response

@post('/process')
def my_process() :
	req_obj = json.loads(request.body.read())
	print(req_obj)	
	return 'All done'

run(host='localhost', port=8888, debug=True)
