from http.server import HTTPServer, SimpleHTTPRequestHandler
from socketserver import ThreadingMixIn
import ssl
import sys


class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    # Support the server's Python 3.6 runtime (ThreadingHTTPServer needs 3.7).
    daemon_threads = True
    request_queue_size = 128
    request_timeout = 15


class HTTPSRequestHandler(SimpleHTTPRequestHandler):
    def setup(self):
        # Run the handshake in this connection's worker, never in accept().
        self.request.settimeout(self.server.request_timeout)
        self.request.do_handshake()
        super().setup()


def main():
    # Retain the hostname/port/key/certificate arguments used by restart-misc.sh.
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.load_cert_chain(certfile=sys.argv[4], keyfile=sys.argv[3])
    with ThreadedHTTPServer(('', int(sys.argv[2])), HTTPSRequestHandler) as httpd:
        httpd.socket = context.wrap_socket(
            httpd.socket, server_side=True, do_handshake_on_connect=False
        )
        httpd.serve_forever()


if __name__ == '__main__':
    main()
