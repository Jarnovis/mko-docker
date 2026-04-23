#!/bin/bash
PROJECT=$(basename "$(dirname "$(dirname "$PWD")")" | tr '[:upper:]' '[:lower:]')

echo "--- Stoppen en afmelden van runner project: $PROJECT ---"

PROJECT="$PROJECT" docker compose -p "$PROJECT" logs -f --no-log-prefix &
LOGS_PID=$!

PROJECT="$PROJECT" docker compose -p "$PROJECT" down --rmi local --remove-orphans

sleep 2
kill $LOGS_PID 2>/dev/null

echo -e "\n--- Runner is succesvol afgemeld en verwijderd! ---"