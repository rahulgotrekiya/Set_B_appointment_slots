# Setup 
```bash
❯ cd ~/Downloads/Set_B_appointment_slots
❯ cat .gitignore
*.tfstate
*.tfstate.*
.terraform/
__pycache__/
*.pyc
.pytest_cache/
.env
generated/service.env
evidence/*.log
```

# Quick local test (before Docker)
```bash
❯ python3 -m unittest discover -s tests -v

test_healthz (test_server.ApiTests.test_healthz) ... ok
test_info (test_server.ApiTests.test_info) ... ok
test_known_item (test_server.ApiTests.test_known_item) ... ok
test_other_url (test_server.ApiTests.test_other_url) ... ok
test_readyz_failure_mode (test_server.ApiTests.test_readyz_failure_mode) ... ok
test_readyz_normal (test_server.ApiTests.test_readyz_normal) ... ok
test_unknown_item (test_server.ApiTests.test_unknown_item) ... ok

----------------------------------------------------------------------
Ran 7 tests in 0.000s

OK
❯ python3 -m app.server
127.0.0.1 "GET /healthz HTTP/1.1" 200 -
127.0.0.1 "GET /favicon.ico HTTP/1.1" 404 -
127.0.0.1 "GET /healthz HTTP/1.1" 200 -
127.0.0.1 "GET /api/slots?department=orthopedics HTTP/1.1" 200 -

❯ curl -i http://127.0.0.1:8080/healthz
HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.14.8
Date: Wed, 25 Nov 2026 10:43:36 GMT
Content-Type: application/json
Content-Length: 19

{"status": "alive"}%
❯ curl -i 'http://127.0.0.1:8080/api/slots?department=orthopedics'


HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.14.8
Date: Wed, 25 Nov 2026 10:43:47 GMT
Content-Type: application/json
Content-Length: 41

{"department": "orthopedics", "slots": 8}%
```