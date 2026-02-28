#!/bin/bash

# 1. Define where the secret file is
SECRET_FILE="/boot/config/scripts/secrets/Daily_Koofr_Backups_secret.conf"

# 2. Check if it exists
if [ -f "$SECRET_FILE" ]; then
    # 3. Import the variables (e.g., DUPLICATI_PASS)
    source "$SECRET_FILE"
else
    echo "Error: Secret config file not found at $SECRET_FILE"
    exit 1
fi

# Log output to flash drive
LOG_FILE="/boot/logs/daily_backup_log.txt"
exec 1>> $LOG_FILE 2>&1

echo "=========================================================="
echo "--- Script Execution Start: $(date) ---"
echo "=========================================================="

# VARIABLES
DBS="postgresql16 mariadb Immich_PostgreSQL mysql"
HOME_SECURITY="home-assistant|zwave-js-ui|frigate|mosquitto|homebridge|coturn"
JOB_ID="2"

# 1. STOP CONTAINERS (SAFETY)
echo "1. Stopping running containers (excluding Duplicati and Home Security)..."
CONTAINERS_TO_STOP=$(docker ps --format '{{.Names}}' --filter status=running | grep -v -E "duplicati|$HOME_SECURITY")

if [ ! -z "$CONTAINERS_TO_STOP" ]; then
    for container in $CONTAINERS_TO_STOP; do
        docker stop $container
        echo "Stopped $container"
    done
else
    echo "No containers found to stop."
fi

# Wait for shutdown
sleep 30

# 2. LOGIN AND TRIGGER BACKUP (SECURE API CALL)
echo "2. Logging in to Duplicati API..."

# Request the Access Token securely by feeding data through standard input to hide it from the ps process list
TOKEN=$(echo "{\"Password\": \"$DUPLICATI_PASS\"}" | curl -s -X POST http://localhost:8200/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d @- | \
  grep -o '"AccessToken":"[^"]*"' | cut -d'"' -f4)

if [ ! -z "$TOKEN" ]; then
    echo "Login successful. Triggering Backup Job ID $JOB_ID..."
    
    # Use the Token to trigger the job
    curl -s -X POST http://localhost:8200/api/v1/backup/$JOB_ID/run \
      -H "Authorization: Bearer $TOKEN"
      
    echo ""
    echo "Backup signal sent. Waiting 600 seconds (10 mins) for backup to run..."
    sleep 600
else
    echo "CRITICAL ERROR: Failed to generate Access Token. Check your secret.conf password."
fi

# 3. START DATABASES FIRST
echo "3. Starting critical databases..."
docker start $DBS

echo "Waiting 30 seconds for databases to stabilize..."
sleep 30

# 4. START ALL REMAINING CONTAINERS
echo "4. Starting all remaining containers..."
docker start $(docker ps -a -q --filter status=exited)

echo "--- Script Execution Finished: $(date) ---"
exit 0