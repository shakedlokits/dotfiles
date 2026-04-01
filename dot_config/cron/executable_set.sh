#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
TASKS="$SCRIPT_DIR/tasks.json"

if [[ ! -f "$TASKS" ]]; then
  echo "error: $TASKS not found" >&2
  exit 1
fi

mkdir -p /tmp/cron

CRONTAB=$(echo "SHELL=/bin/zsh"; jq -r '.tasks[] | "\(.schedule)  source ~/.zshrc && \(.command) >> /tmp/cron/\(.name).log 2>&1"' "$TASKS")

echo "$CRONTAB"
echo ""
echo "$CRONTAB" | crontab -
echo "crontab installed successfully"
