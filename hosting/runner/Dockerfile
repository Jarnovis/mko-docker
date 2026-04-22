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
