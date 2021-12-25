# Copyright (c) 2021 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
# Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-covid19-data-backend-processing for more information.

FROM --platform=$BUILDPLATFORM debian:buster-slim

# Set environmental settings
ENV RUNNER_NAME="default"
ENV RUNNER_WORK_DIRECTORY=""
ENV RUNNER_TOKEN=""
ENV RUNNER_REPOSITORY_URL=""
ENV RUNNER_LABELS=""
ENV GITHUB_ACCESS_TOKEN=""
ENV RUNNER_ALLOW_RUNASROOT=false
ENV AGENT_TOOLS_DIRECTORY=/opt/hosted-tool-cache

ARG OWNER="minvws"
ARG REPOSITORY_NAME="nl-covid19-data-backend-processing"

LABEL org.opencontainers.image.source https://github.com/${OWNER}/${REPOSITORY_NAME}

# Install needed packages. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
COPY library-scripts/*.sh /tmp/library-scripts/

ARG USE_MOBY=false
ARG UPGRADE_PACKAGES=true
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/docker-debian.sh "${USE_MOBY}" "${UPGRADE_PACKAGES}" \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf

# Install and setup self-hosted runner
RUN mkdir -p /root/.action-runner ${AGENT_TOOLS_DIRECTORY}

WORKDIR /root/.action-runner

ARG GITHUB_RUNNER_VERSION
RUN GITHUB_RUNNER_VERSION=${GITHUB_RUNNER_VERSION:-$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} \
    && curl -L -O https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz \
    && tar -zxf actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz \
    && rm -f actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz \
    && ./bin/installdependencies.sh \
    && chown -R root: /root/.action-runner \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Run self-hosted runner
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
