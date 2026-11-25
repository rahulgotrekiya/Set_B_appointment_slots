#!/usr/bin/env bash

# Check if log file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <log-file>"
    exit 1
fi

# Check if file exists
if [ ! -f "$1" ]; then
    echo "Error: Log file not found!"
    exit 1
fi

# Count total requests
total=$(wc -l < "$1")

# Count 4xx errors
errors_4xx=$(awk '$2 ~ /^4/ {count++} END {print count+0}' "$1")

# Count 5xx errors
errors_5xx=$(awk '$2 ~ /^5/ {count++} END {print count+0}' "$1")

# Print results
echo "Total Requests: $total"
echo "HTTP 4xx Errors: $errors_4xx"
echo "HTTP 5xx Errors: $errors_5xx"

# Find top 3 common routes
echo ""
echo "Top 3 Most Common Routes:"

awk '{print $4}' "$1" | sort | uniq -c | sort -nr | head -3
