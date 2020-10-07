import http.client

c = http.client.HTTPConnection('localhost', 8888)
c.request('POST', '/process', '{"rara" : 3}')
doc = c.getresponse().read()
print(doc)
