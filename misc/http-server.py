import BaseHTTPServer, SimpleHTTPServer
import ssl
import sys

httpd = BaseHTTPServer.HTTPServer((sys.argv[1], sys.argv[2]), SimpleHTTPServer.SimpleHTTPRequestHandler)
httpd.socket = ssl.wrap_socket (httpd.socket, certfile=sys.argv[3], server_side=True)
httpd.serve_forever()