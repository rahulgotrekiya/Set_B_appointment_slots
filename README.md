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

```bash
❯ git checkout -b feature/devops-pipeline

Switched to a new branch 'feature/devops-pipeline'

❯ chmod +x scripts/analyze_logs.sh
❯ ./scripts/analyze_logs.sh logs/access.log
Total Requests: 24
HTTP 4xx Errors: 4
HTTP 5xx Errors: 2

Top 3 Most Common Routes:
      8 /healthz
      6 /api/slots?department=orthopedics
      5 /readyz

❯ ./scripts/analyze_logs.sh logs/access.log | tee evidence/01-logs.txt
Total Requests: 24
HTTP 4xx Errors: 4
HTTP 5xx Errors: 2

Top 3 Most Common Routes:
      8 /healthz
      6 /api/slots?department=orthopedics
      5 /readyz
    
```

# Terraform
```bash
❯ cd infra

❯ cp dev.tfvars.example dev.tfvars
❯ terraform fmt -recursive
dev.tfvars
❯ terraform fmt -check -recursive
❯ terraform init
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/local versions matching "~> 2.5"...
- Installing hashicorp/local v2.9.1...
- Installed hashicorp/local v2.9.1 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
❯ terraform validate

Success! The configuration is valid.

❯ terraform plan -var-file=dev.tfvars

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.service_env will be created
  + resource "local_file" "service_env" {
      + content              = <<-EOT
            APP_NAME=appointment-slots
            APP_ENV=dev
            LOG_LEVEL=INFO
            PORT=8080
            FAIL_MODE=0
        EOT
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0644"
      + filename             = "./../generated/service.env"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + service_env_file = "./../generated/service.env"

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply"
now.

victus ~/Downloads/Set_B_appointment_slots/infra 󰘬 feature/devops-pipeline*
❯                                                                                                                                     17:07:23
```

# Docker
```bash
❯ docker compose ps
NAME                            IMAGE                     COMMAND                  SERVICE   CREATED         STATUS                            PORTS
set_b_appointment_slots-api-1   appointment-slots:local   "python -m app.server"   api       3 seconds ago   Up 2 seconds (health: starting)   127.0.0.1:8080->8080/tcp

❯ curl -i http://127.0.0.1:8080/healthz
curl -i http://127.0.0.1:8080/readyz
curl -i 'http://127.0.0.1:8080/api/slots?department=orthopedics'
curl -i http://127.0.0.1:8080/info
curl -i http://127.0.0.1:8080/unknown

HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.12.16
Date: Wed, 25 Nov 2026 11:42:09 GMT
Content-Type: application/json
Content-Length: 19

{"status": "alive"}HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.12.16
Date: Wed, 25 Nov 2026 11:42:09 GMT
Content-Type: application/json
Content-Length: 19

{"status": "ready"}HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.12.16
Date: Wed, 25 Nov 2026 11:42:09 GMT
Content-Type: application/json
Content-Length: 41

{"department": "orthopedics", "slots": 8}HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.12.16
Date: Wed, 25 Nov 2026 11:42:10 GMT
Content-Type: application/json
Content-Length: 50

{"app": "appointment-slots", "environment": "dev"}HTTP/1.0 404 Not Found
Server: BaseHTTP/0.6 Python/3.12.16
Date: Wed, 25 Nov 2026 11:42:10 GMT
Content-Type: application/json
Content-Length: 27

{"error": "path_not_found"}%
❯
❯ docker compose exec api id
uid=10001(appuser) gid=10001(appuser) groups=10001(appuser)
❯ docker inspect --format '{{.State.Health.Status}}' $(docker compose ps -q api)

healthy
❯ docker compose logs api
api-1  | 127.0.0.1 "GET /healthz HTTP/1.1" 200 -
api-1  | 127.0.0.1 "GET /healthz HTTP/1.1" 200 -
api-1  | 127.0.0.1 "GET /healthz HTTP/1.1" 200 -
api-1  | 172.18.0.1 "GET /healthz HTTP/1.1" 200 -
api-1  | 172.18.0.1 "GET /readyz HTTP/1.1" 200 -
api-1  | 172.18.0.1 "GET /api/slots?department=orthopedics HTTP/1.1" 200 -
api-1  | 172.18.0.1 "GET /info HTTP/1.1" 200 -
api-1  | 172.18.0.1 "GET /unknown HTTP/1.1" 404 -
api-1  | 127.0.0.1 "GET /healthz HTTP/1.1" 200 -
api-1  | 127.0.0.1 "GET /healthz HTTP/1.1" 200 -
❯ docker compose down
docker compose ps

[+] down 2/2
 ✔ Container set_b_appointment_slots-api-1 Removed                                                                                         10.1s
 ✔ Network set_b_appointment_slots_default Removed                                                                                          0.1s
NAME      IMAGE     COMMAND   SERVICE   CREATED   STATUS    PORTS

victus ~/Downloads/Set_B_appointment_slots 󰘬 feature/devops-pipeline*
❯
```