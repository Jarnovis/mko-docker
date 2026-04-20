# Docker runner hosten
## Wat is een runner?
Voor developer gebruik is het toepasselijk om (in het geval van GitHub) een actionsrunner te gebruiken. In deze runner worden .yml files gedraaid die getriggerd worden door acties op geselecteerde branches.

Bij GitHub kun je runners huren. Deze runners worden aan de eind van de maand in kosten gebracht en verschillen tussen per model. De kosten zijn voor de gebruikte minuten van runner. Oftewel als er geen workflow draaiende is, worden er geen kosten in kaart gebracht.

Voor runners worden er voor publieke repositories geen kosten in kaart gebracht, zodat de GitHub community beschikbaar wordt voor publieke doeleindes.

GitHub heeft abonementen, waardoor de kosten van runners minder worden. Er zijn drie verschillende soorten abonnementen waar gebruik gemaakt van kunnen worden. Deze gratis minuten gelden voor de self-hosted runners of de 'gratis' runners van GitHub.

Item | Free | Team | Enterpise
---- | ---- | ---- | ---------
Kosten | $0 USD per user/month | $4 USD per user/month | $21 USD per user/month
GitHub Actions | 2,000 minutes/month (Free for public repositories) | 3,000 minutes/month (Free for public repositories) | 50,000 minutes/month (Free for public repositories)


## Kosten runners
### Linux
Hardware | Core size | Prijs / minuut
-------- | --------- | -----
x64 | 1 | $0.002
x64 | 2 | $0.006
x64 | 4 | $0.012
x64 | 8 | $0.022
x64 | 16 | $0.042
x64 | 32 | $0.082
x64 | 64 | $0.162
x64 | 96 | $0.252

Hardware | Core size | Prijs / minuut
-------- | --------- | -----
ARM64 | 2 | $0.005
ARM64 | 4 | $0.008
ARM64 | 8 | $0.014
ARM64 | 16 | $0.026
ARM64 | 32 | $0.050
ARM64 | 64 | $0.98

Hardware | Core size | Prijs / minuut
-------- | --------- | -----
GPU-powerd | 4 | $0.052

### Windows
Hardware | Core size | Prijs / minuut
-------- | --------- | -----
x64 | Server 2 | $0.010
x64 | Desktop 4| $0.022
x64 | Server 8 | $0.042
x64 | Server 16 | $0.082
x64 | Server 32 | $0.162
x64 | Server  64 | $0.322
x64 | Server 96 | $0.552

Hardware | Core size | Prijs / minuut
-------- | --------- | -----
ARM64 | Desktop 2 | $0.008
ARM64 | Desktop 4 | $0.014
ARM64 | Desktop 8 | $0.026
ARM64 | Desktop 16 | $0.050
ARM64 | Desktop 32 | $0.098
ARM64 | Desktop 64 | $0.194

Hardware | Core size | Prijs / minuut
-------- | --------- | -----
GPU-powerd | 4 | $0.102

### macOS
Hardware | Core size | Prijs / minuut
-------- | --------- | -----
x64 | 4 (Intel) | $0.062
x64 | 12 (Intel) | $0.077

Hardware | Core size | Prijs / minuut
-------- | --------- | -----
ARM64 | 3 (M1) | $0.062
ARM64 | 5 (M2 Pro) | $0.102

### Self hosted
Sinds 1 Januarri 2016 worden er kosten in kaart gebracht voor het hosten van een eigen runner. Deze kosten bedragen **$0.002 per minuut**, onafhankelijk welk soort model je gebruikt.

## Self hosted runner hosten
Op een device kan je standaard **één** runner hosten via de terminal. Het nadeel hiervan is dat deze terminal altijd open moet staan en dat je er maar één runner kan draaien, wat vervelend is als je bezig bent met meerdere projecten.

De oplossing voor dit probleem is Docker. Hiermee kan je meerdere runners voor één of meerdere GitHub repositories gebruiken. Tijdens dit project wordt er uitleg gegeven over hoe je één of meerdere runners binnen een project kan gebruiken.

### Runnen met Docker
#### Docker-compose.yml
Docker-compose.yml zorgt ervoor dat docker alle containers, netwerken en variabelen instelt.
``` yml
services:
  github-runner1:
    build: 
      context: .
      args: 
        GITHUB_PAT: ${GITHUB_PAT}
      
    container_name: "github-runner1-${PROJECT}"
    restart: unless-stopped 
    environment:
      RUNNER_URL: ${RUNNER_URL}
      RUNNER_WORKDIR: /home/runner/_work
      LABELS: self-hosted,Linux,X64,${PROJECT}
      EPHEMERAL: 0
      PROJECT: ${PROJECT}
      GITHUB_PAT: ${GITHUB_PAT}
      REPO_OWNER: ${REPO_OWNER}
      REPO_NAME: ${REPO_NAME}
      NUMBER: 1
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - internal

networks:
  internal:

volumes:
  gh-pages-data:
  runner-data:

```
#### Dockerfile

``` Dockerfile
# Waar de runner op draait
FROM ubuntu:22.04

# Default antwoorden worden door gegeven op vragen
ENV DEBIAN_FRONTEND=noninteractive

# GitHub Personal Acces Token (PAT) ophalen uit de .env file
ARG GITHUB_PAT
ENV GITHUB_PAT=${GITHUB_PAT}

# Tijdszone instellen
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Standaard installaties voor het opzetten van de runner
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    jq \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    libicu70 && \
    rm -rf /var/lib/apt/lists/*

# Een non-root gebruiker 'runner' aanmaken met sudo rechten
RUN useradd -m runner && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Werkmap bepalen
WORKDIR /home/runner

# Code om de runner automatisch te laten registreren 
RUN ARCH=$(uname -m) && \
  # Type architectuur vaststellen 
    case "$ARCH" in \
      x86_64) ARCH="x64" ;; \
      aarch64|arm64) ARCH="arm64" ;; \
      armv7l|armhf) ARCH="arm" ;; \
      *) echo "Unsupported architecture: $ARCH"; exit 1 ;; \
    esac && \
    echo "Detected architecture: $ARCH" && \
    # Download URL voor runner vast stellen
    RUNNER_URL=$(curl -s \
      -H "Authorization: token ${GITHUB_PAT}" \
      https://api.github.com/repos/actions/runner/releases/latest \
      | jq -r ".assets[] | select(.name | contains(\"linux-$ARCH\") and endswith(\".tar.gz\")) | .browser_download_url") && \
    echo "Downloading: $RUNNER_URL" && \
    # Runner downloaden (Gecomprimeerd bestand)
    curl -L -H "Authorization: token ${GITHUB_PAT}" \
      -o actions-runner.tar.gz "$RUNNER_URL" && \
    # Gecomprimeerd bestand uitpakken en verwijderen
    tar xzf actions-runner.tar.gz && rm actions-runner.tar.gz

# Vanaf hier alle commando's uitvoeren als de 'runner' gebruiker
USER runner

# Zorgen dat het script uitvoerbaar is en eventuele Windows-regeleinden (CRLF) verwijderen
COPY --chown=runner:runner entrypoint.sh /home/runner/entrypoint.sh

RUN sudo apt-get update && \
    sudo apt-get install -y sed && \
    sed -i 's/\r//g' /home/runner/entrypoint.sh && \
    chmod +x /home/runner/entrypoint.sh

ENTRYPOINT ["/home/runner/entrypoint.sh"]
```

#### entrypoint.sh
``` sh
#!/bin/bash
set -e
# Tijdszone goed zetten voor shellscript
export TZ=${TZ:-Europe/Amsterdam}


cleanup() {
  echo "Runner wordt afgemeld bij GitHub..."

  REMOVE_TOKEN=$(curl -sX POST \
      -H "Authorization: token ${GITHUB_PAT}" \
      "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/actions/runners/remove-token"
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
echo "Runner $RUNNER_NAME gestart..."
echo "=========================================="
exec ./run.sh
```

#### start_runner.sh
Start runner.sh is en script waardoor er geen gebruik gemaakt hoeft te worden van de Docker commants om de runner snel aan te zetten
``` sh
#!/bin/bash
set -e
cd "$(dirname "$0")"

PROJECT=$(basename "$(dirname "$(dirname "$PWD")")" | tr '[:upper:]' '[:lower:]')
IMAGE_NAME="${PROJECT}-github-runner"

echo "--- Start runner voor project: $PROJECT ---"

# Controleer of image al bestaat — bouwen indien nodig
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
```

#### stop_runner.sh
Stop runner.sh is en script waardoor er geen gebruik gemaakt hoeft te worden van de Docker commants om de runner te laten deregistreren en te verwijderen
``` sh
#!/bin/bash
PROJECT=$(basename "$(dirname "$(dirname "$PWD")")" | tr '[:upper:]' '[:lower:]')

echo "--- Stoppen en afmelden van runner project: $PROJECT ---"

PROJECT="$PROJECT" docker compose -p "$PROJECT" logs -f --no-log-prefix &
LOGS_PID=$!

PROJECT="$PROJECT" docker compose -p "$PROJECT" down --rmi local --remove-orphans

sleep 2
kill $LOGS_PID 2>/dev/null

echo -e "\n--- Runner is succesvol afgemeld en verwijderd! ---"
```