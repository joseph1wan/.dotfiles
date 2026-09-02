#!/bin/bash

# Background daemon to auto-refresh AWS credentials using awsl
# Usage: awsl-refresh-daemon.sh <env>

set -e

ENV="${1:-stg}"

# Validate environment
case "$ENV" in
  dev|stg|prd)
    ;;
  *)
    echo "Invalid environment: $ENV. Must be dev, stg, or prd"
    exit 1
    ;;
esac

# Source adsk.sh to get awsl function
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/adsk.sh"

# PID and log file paths
PID_FILE="$HOME/.awsl-refresh-$ENV.pid"
LOG_FILE="$HOME/.awsl-refresh-$ENV.log"

# Function to log messages
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $*" >> "$LOG_FILE"
}

# Function to cleanup on exit
cleanup() {
  log "Shutting down daemon for $ENV"
  rm -f "$PID_FILE"
  exit 0
}

# Trap signals for graceful shutdown
trap cleanup SIGTERM SIGINT

# Check if already running
if [ -f "$PID_FILE" ]; then
  OLD_PID=$(cat "$PID_FILE")
  if ps -p "$OLD_PID" > /dev/null 2>&1; then
    echo "Daemon already running for $ENV (PID: $OLD_PID)"
    exit 1
  else
    # Stale PID file, remove it
    rm -f "$PID_FILE"
  fi
fi

# Write PID file
echo $$ > "$PID_FILE"
log "Starting awsl-refresh daemon for $ENV (PID: $$)"

# Main loop: refresh every 25 minutes (1500 seconds)
while true; do
  log "Refreshing credentials for $ENV"
  # Run awsl and capture only errors to log, suppress normal output
  if awsl "$ENV" > /dev/null 2>> "$LOG_FILE"; then
    log "Successfully refreshed credentials for $ENV"
  else
    log "ERROR: Failed to refresh credentials for $ENV"
  fi
  
  # Sleep for 20 minutes (1200 seconds) before next refresh
  sleep 1200
done

