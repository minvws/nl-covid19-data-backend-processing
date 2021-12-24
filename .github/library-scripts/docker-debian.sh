#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# -- Copyright (c) 2021 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
# -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-covid19-data-backend-processing for more information.
#-------------------------------------------------------------------------------------------------------------
#
# Syntax: ./docker-debian.sh [use moby] [upgrade packages]

USE_MOBY=${1:-"true"}
UPGRADE_PACKAGES=${2:-"true"}

set -e

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Function to run apt-get if needed
apt-get-update-if-needed()
{
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update
    else
        echo "Skipping apt-get update."
    fi
}

# Install package list(s)
PACKAGE_LIST="curl \
    unzip \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    sudo \
    git \
    supervisor \
    jq \
    iputils-ping \
    build-essential \
    zlib1g-dev \
    gettext \
    liblttng-ust0 \
    libcurl4-openssl-dev \
    openssh-client"

apt-get-update-if-needed

echo "Packages to verify are installed: ${PACKAGE_LIST}"
apt-get -y install --no-install-recommends ${PACKAGE_LIST} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )

# Install apt-transport-https, curl, lsb-release, gpg if missing
if ! dpkg -s apt-transport-https curl ca-certificates lsb-release > /dev/null 2>&1 || ! type gpg > /dev/null 2>&1; then
    apt-get-update-if-needed
    apt-get -y install --no-install-recommends apt-transport-https curl ca-certificates lsb-release gnupg2 
fi

# Get to latest versions of all packages
if [ "${UPGRADE_PACKAGES}" = "true" ]; then
    apt-get-update-if-needed
    apt-get -y upgrade --no-install-recommends
    apt-get autoremove -y
fi

# Install Docker / Moby CLI if not already installed
if type docker > /dev/null 2>&1; then
    echo "Docker / Moby CLI already installed."
else
    if [ "${USE_MOBY}" = "true" ]; then
        DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
        CODENAME=$(lsb_release -cs)
        curl -s https://packages.microsoft.com/keys/microsoft.asc | (OUT=$(apt-key add - 2>&1) || echo $OUT)
        echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-${DISTRO}-${CODENAME}-prod ${CODENAME} main" > /etc/apt/sources.list.d/microsoft.list
        apt-get update
        apt-get -y install --no-install-recommends moby-cli moby-buildx
    else
        curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | (OUT=$(apt-key add - 2>&1) || echo $OUT)
        echo "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
        apt-get update
        apt-get -y install --no-install-recommends docker-ce-cli
    fi
fi

# Install Docker Compose if not already installed 
if type docker-compose > /dev/null 2>&1; then
    echo "Docker Compose already installed."
else
    LATEST_COMPOSE_VERSION=$(basename "$(curl -fsSL -o /dev/null -w "%{url_effective}" https://github.com/docker/compose/releases/latest)")
    curl -fsSL "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Install Powershell
if type pwsh > /dev/null 2>&1; then
    echo "Powershell already installed."
else
    DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    DISTRO_VERSION=10
    curl -L -O "https://packages.microsoft.com/config/${DISTRO}/${DISTRO_VERSION}/packages-microsoft-prod.deb"
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y powershell

    rm -rf packages-microsoft-prod.deb
fi
echo "Done!"
