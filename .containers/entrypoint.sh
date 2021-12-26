#!/bin/bash
# Copyright (c) 2021 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
# Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-covid19-data-backend-processing for more information.

if [[ "$@" == "bash" ]]; then
    exec $@
fi

if [[ -z $GITHUB_RUNNER_NAME ]]; then
    echo "GITHUB_RUNNER_NAME environment variable is not set, using '${HOSTNAME}'."
    export GITHUB_RUNNER_NAME=${HOSTNAME}
fi

if [[ -z $GITHUB_RUNNER_WORK_DIRECTORY ]]; then
    echo "GITHUB_RUNNER_WORK_DIRECTORY environment variable is not set, using '_work'."
    export GITHUB_RUNNER_WORK_DIRECTORY="_work"
fi

if [[ -z $GITHUB_RUNNER_TOKEN && -z $GITHUB_ACCESS_TOKEN ]]; then
    echo "Error : You need to set GITHUB_RUNNER_TOKEN (or GITHUB_ACCESS_TOKEN) environment variable."
    exit 1
fi

if [[ -z $GITHUB_RUNNER_REPOSITORY_URL && -z $GITHUB_RUNNER_ORGANIZATION_URL ]]; then
    echo "Error : You need to set the GITHUB_RUNNER_REPOSITORY_URL (or GITHUB_RUNNER_ORGANIZATION_URL) environment variable."
    exit 1
fi

if [[ -z $GITHUB_RUNNER_REPLACE_EXISTING ]]; then
    export GITHUB_RUNNER_REPLACE_EXISTING="true"
fi

CONFIG_OPTS=""
if [ "$(echo $GITHUB_RUNNER_REPLACE_EXISTING | tr '[:upper:]' '[:lower:]')" == "true" ]; then
	CONFIG_OPTS="--replace"
fi

if [[ -n $GITHUB_RUNNER_LABELS ]]; then
    CONFIG_OPTS="${CONFIG_OPTS} --labels ${GITHUB_RUNNER_LABELS}"
fi

export RUNNER_ALLOW_RUNASROOT=$GITHUB_RUNNER_ALLOW_RUNASROOT

if [[ -f ".runner" ]]; then
    echo "Runner already configured. Skipping config."
else
    if [[ ! -z $GITHUB_RUNNER_ORGANIZATION_URL ]]; then
        SCOPE="orgs"
        GITHUB_RUNNER_URL="${GITHUB_RUNNER_ORGANIZATION_URL}"
    else
        SCOPE="repos"
        GITHUB_RUNNER_URL="${GITHUB_RUNNER_REPOSITORY_URL}"
    fi

    if [[ -n $GITHUB_ACCESS_TOKEN ]]; then

        echo "Exchanging the GitHub Access Token with a Runner Token (scope: ${SCOPE})..."

        _PROTO="$(echo "${GITHUB_RUNNER_URL}" | grep :// | sed -e's,^\(.*://\).*,\1,g')"
        _URL="$(echo "${GITHUB_RUNNER_URL/${_PROTO}/}")"
        _PATH="$(echo "${_URL}" | grep / | cut -d/ -f2-)"

        GITHUB_RUNNER_TOKEN="$(curl -XPOST -fsSL \
            -H "Authorization: token ${GITHUB_ACCESS_TOKEN}" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/${SCOPE}/${_PATH}/actions/runners/registration-token" \
            | jq -r '.token')"
    fi

    ./config.sh \
        --url $GITHUB_RUNNER_URL \
        --token $GITHUB_RUNNER_TOKEN \
        --name $GITHUB_RUNNER_NAME \
        --work $GITHUB_RUNNER_WORK_DIRECTORY \
        $CONFIG_OPTS \
        --unattended
fi

exec "$@"