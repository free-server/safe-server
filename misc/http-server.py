# Python 2
# import BaseHTTPServer, SimpleHTTPServer
# import ssl
# import sys

# httpd = BaseHTTPServer.HTTPServer(('', int(sys.argv[2])), SimpleHTTPServer.SimpleHTTPRequestHandler)
# httpd.socket = ssl.wrap_socket (httpd.socket, keyfile=sys.argv[3], certfile=sys.argv[4], server_side=True)
# httpd.serve_forever()

# Python 3
from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl
import sys

httpd = HTTPServer(('', int(sys.argv[2])), BaseHTTPRequestHandler)

httpd.socket = ssl.wrap_socket (httpd.socket, 
        keyfile=sys.argv[3], 
        certfile=sys.argv[4], server_side=True)

httpd.serve_forever()