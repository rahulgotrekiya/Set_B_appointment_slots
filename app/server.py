"""Provided starter: platform assessment HTTP API. Application changes are NOT required."""
import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlsplit, parse_qs

API_PATH = '/api/slots'
QUERY_KEY = 'department'
KNOWN_VALUE = 'orthopedics'
RESULT_KEY = 'slots'
RESULT_VALUE = 8

def route(url, env=None):
    env = os.environ if env is None else env
    parsed = urlsplit(url)
    if parsed.path == '/healthz':
        return 200, {'status': 'alive'}
    if parsed.path == '/readyz':
        failing = str(env.get('FAIL_MODE', '0')).lower() in ('1', 'true', 'yes')
        return (503 if failing else 200), {'status': 'unavailable' if failing else 'ready'}
    if parsed.path == '/info':
        return 200, {'app': env.get('APP_NAME', 'appointment-slots'), 'environment': env.get('APP_ENV', 'dev')}
    if parsed.path == API_PATH:
        value = parse_qs(parsed.query).get(QUERY_KEY, [''])[0]
        if value == KNOWN_VALUE:
            return 200, {QUERY_KEY: value, RESULT_KEY: RESULT_VALUE}
        return 404, {'error': 'item_not_found'}
    return 404, {'error': 'path_not_found'}

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        code, payload = route(self.path)
        body = json.dumps(payload).encode('utf-8')
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)
    def log_message(self, fmt, *args):
        print('%s %s' % (self.address_string(), fmt % args), flush=True)

if __name__ == '__main__':
    port = int(os.getenv('PORT', '8080'))
    ThreadingHTTPServer(('0.0.0.0', port), Handler).serve_forever()
