#!/bin/bash
set -e
# Tijdszone goed zetten voor shellscript
export TZ=${TZ:-Europe/Amsterdam}


cleanup() {
  echo "Runner wordt afgemeld bij GitHub..."

  REMOVE_TOKEN=$(curl -sX POST \
      -H "Authorization: token ${GITHUB_PAT}" \
      "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/actions/runners/remove-token" \
 | jq -r .token)

  if [ -z "$REMOVE_TOKEN" ]; then
    echo "Kon geen removal-token ophalen (handmatig verwijderen)."
    return
  fi

  ./config.sh remove --unattended --token "$REMOVE_TOKEN" || true
}

trap cleanup EXIT SIGINT SIGTERM

RUNNER_TOKEN=$(curl -sX POST \
  -H "Authorization: token ${GITHUB_PAT}" \
  https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/actions/runners/registration-token \
  | jq -r .token)

if [ -z "$RUNNER_TOKEN" ] || [ -z "$RUNNER_URL" ]; then
  echo "ERROR: RUNNER_TOKEN en RUNNER_URL moeten ingesteld zijn."
  exit 1
fi

UTC_TS=$(date -u '+D%dM%mY%Y H%HM%MS%S UTC')
RUNNER_NAME="${REPO_NAME}-${NUMBER}-${UTC_TS}"

echo "=========================================="
echo "Project: $REPO_NAME"
echo "Runner naam: $RUNNER_NAME"
echo "Runner URL: $RUNNER_URL"
echo "=========================================="

echo "Controleer of runner al geconfigureerd is..."
if [ ! -f .runner ]; then
  echo "Configureren runner $RUNNER_NAME voor $RUNNER_URL"
  
  if [ "$EPHEMERAL" = "1" ]; then
    EXTRA_ARGS="--ephemeral"
  fi

  ./config.sh \
    --url "$RUNNER_URL" \
    --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" \
    --work _work \
    --labels "$LABELS" \
    --unattended \
    $EXTRA_ARGS
else
  echo "Runner al geconfigureerd, sla config stap over."
fi

echo "=========================================="
echo "Runner $RUNNER_NAME gestart met PID $$..."
echo "=========================================="

# Start de runner op de achtergrond
./run.sh &
PID=$!

# Zorg dat we het signaal doorgeven aan de cleanup
while kill -0 $PID 2>/dev/null; do
    wait $PID || true
done

echo "Container proces afgesloten."