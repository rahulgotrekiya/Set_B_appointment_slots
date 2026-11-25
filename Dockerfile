# Candidate: author Dockerfile; use non-root user and HEALTHCHECK

FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Create a normal user so the app does not run as root
RUN useradd --uid 10001 --no-create-home appuser

# Copy only the application code
COPY app/ ./app/

# Switch to the non-root user
USER 10001

# The app listens on port 8080
EXPOSE 8080

# Docker checks /healthz every 15 seconds.
# The slim image has no curl, so I use Python to make the request.
HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/healthz', timeout=2)" || exit 1

# Start the server
CMD ["python", "-m", "app.server"]
