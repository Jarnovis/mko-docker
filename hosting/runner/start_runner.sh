#!/bin/bash
set -e
cd "$(dirname "$0")"

PROJECT=$(basename "$(dirname "$(dirname "$PWD")")" | tr '[:upper:]' '[:lower:]')
IMAGE_NAME="${PROJECT}-github-runner"

echo "--- Start runner voor project: $PROJECT ---"

# Controleerr of image al bestaat — bouwen indien nodig
if ! docker image inspect "$IMAGE_NAME:latest" >/dev/null 2>&1; then
    echo "Geen bestaande image gevonden — bouwen..."
    PROJECT="$PROJECT" docker compose -p "$PROJECT" build --progress=plain
else
    echo "Image $IMAGE_NAME bestaat al."
fi

# ontainers starten in de achtergrond
echo "Containers starten..."
PROJECT="$PROJECT" docker compose -p "$PROJECT" up -d

# ogs streamen totdat de verbinding is bevestigd
echo "Wachten op verbinding met GitHub..."

PROJECT="$PROJECT" docker compose -p "$PROJECT" logs -f --no-log-prefix | grep -m 1 "Connected to GitHub"

echo -e "\n--- Runner is succesvol verbonden met GitHub! ---"