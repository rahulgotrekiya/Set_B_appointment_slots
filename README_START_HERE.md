# Set B starter - Outpatient Appointment Slots API

Application code and unit tests are supplied. Do not spend assessment time rewriting the service.

## Quick local test (before Docker)

```bash
python3 -m unittest discover -s tests -v
python3 -m app.server
curl -i http://127.0.0.1:8080/healthz
curl -i 'http://127.0.0.1:8080/api/slots?department=orthopedics'
```

## API behavior
- GET /healthz : 200 if process is responsive
- GET /readyz : 200 normally; 503 when `FAIL_MODE=1`
- GET /info : app metadata from environment
- GET /api/slots?department=orthopedics : sample data

## Access logs
logs/access.log uses: `ISO8601 HTTP_STATUS METHOD URL duration_ms=N`.
Derive the request totals, status counts, 5xx rate and most frequent routes yourself.

## Terraform
Complete `infra/` so Terraform creates `generated/service.env`.
Run Terraform from the infra/ directory. Generated state/config must not be committed.

## Deliverables
See the separately distributed Set B candidate assignment PDF.
