#!/bin/bash
set -e

if [ -z "$DEVOPS_AGENT_REPOSITORY_URL" ]; then
    echo 1>&2 "error: missing DEVOPS_AGENT_REPOSITORY_URL environment variable"
    exit 1
fi

if [ -z "$DEVOPS_AGENT_TOKEN_FILE" ]; then
    if [ -z "$DEVOPS_AGENT_TOKEN" ]; then
        echo 1>&2 "error: missing DEVOPS_AGENT_TOKEN environment variable"
        exit 1
    fi

    DEVOPS_AGENT_TOKEN_FILE=./.token
    echo -n $DEVOPS_AGENT_TOKEN > "$DEVOPS_AGENT_TOKEN_FILE"
fi

unset DEVOPS_AGENT_TOKEN

if [ -n "$DEVOPS_AGENT_WORK" ]; then
    mkdir -p "$DEVOPS_AGENT_WORK"
fi

export AGENT_ALLOW_RUNASROOT="1"

cleanup() {
    if [ -e config.sh ]; then
        print_header "Cleanup. Removing Azure Pipelines agent..."

        # If the agent has some running jobs, the configuration removal process will fail.
        # So, give it some time to finish the job.
        while true; do
            ./config.sh remove --unattended --auth PAT --token $(cat "$DEVOPS_AGENT_TOKEN_FILE") && break

            echo "Retrying in 30 seconds..."
            sleep 30
        done
    fi
}

print_header() {
    lightcyan='\033[1;36m'
    nocolor='\033[0m'
    echo -e "${lightcyan}$1${nocolor}"
}

# Let the agent ignore the token env variables
export VSO_AGENT_IGNORE=DEVOPS_AGENT_TOKEN,DEVOPS_AGENT_TOKEN_FILE

print_header "1. Determining matching Azure Pipelines agent..."

DEVOPS_AGENT_AGENT_PACKAGES=$(curl -LsS \
    -u user:$(cat "$DEVOPS_AGENT_TOKEN_FILE") \
    -H 'Accept:application/json;' \
    "$DEVOPS_AGENT_REPOSITORY_URL/_apis/distributedtask/packages/agent?platform=$TARGETARCH&top=1")

DEVOPS_AGENT_AGENT_PACKAGE_LATEST_URL=$(echo "$DEVOPS_AGENT_AGENT_PACKAGES" | jq -r '.value[0].downloadUrl')

if [ -z "$DEVOPS_AGENT_AGENT_PACKAGE_LATEST_URL" -o "$DEVOPS_AGENT_AGENT_PACKAGE_LATEST_URL" == "null" ]; then
    echo 1>&2 "error: could not determine a matching Azure Pipelines agent"
    echo 1>&2 "check that account '$DEVOPS_AGENT_REPOSITORY_URL' is correct and the token is valid for that account"
    exit 1
fi

print_header "2. Downloading and extracting Azure Pipelines agent..."

curl -LsS $DEVOPS_AGENT_AGENT_PACKAGE_LATEST_URL | tar -xz & wait $!

source ./env.sh

print_header "3. Configuring Azure Pipelines agent..."

./config.sh --unattended \
    --agent "${DEVOPS_AGENT_AGENT_NAME:-$(hostname)}" \
    --url "$DEVOPS_AGENT_REPOSITORY_URL" \
    --auth PAT \
    --token $(cat "$DEVOPS_AGENT_TOKEN_FILE") \
    --pool "${DEVOPS_AGENT_POOL:-Default}" \
    --work "${DEVOPS_AGENT_WORK:-_work}" \
    --replace \
    --acceptTeeEula & wait $!

print_header "4. Running Azure Pipelines agent..."

trap 'cleanup; exit 0' EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

chmod +x ./run-docker.sh

# To be aware of TERM and INT signals call run.sh
# Running it with the --once flag at the end will shut down the agent after the build is executed
./run-docker.sh "$@" & wait $!