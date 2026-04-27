#
# OCI base image for worker-vscode.
#

ARG OPENVSCODE_PINNED_VERSION=1.109.5
FROM lscr.io/linuxserver/openvscode-server:${OPENVSCODE_PINNED_VERSION}

#NOT: USER openvscode-server
USER root

ENV DEBIAN_FRONTEND=noninteractive \
    OPENVSCODE_PINNED_VERSION=${OPENVSCODE_PINNED_VERSION} \
    OPENVSCODE_IMAGE_REF=lscr.io/linuxserver/openvscode-server:${OPENVSCODE_PINNED_VERSION} \
    OPENVSCODE_USER_DATA_DIR=/config/data \
    OPENVSCODE_EXTENSIONS_DIR=/config/extensions \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    VSCODE_SNAPSHOT_ROOT=/workspace/config/vscode/snapshots

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y \
        git \
        less \
        openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN    date -u +"%Y-%m-%dT%H:%M:%S%:z" >>      /root/.worker-vscode-image-github-build-was-here \
    && mkdir -p                           /workspace \
    && date -u +"%Y-%m-%dT%H:%M:%S%:z" >> /workspace/.worker-vscode-image-github-build-was-here 


RUN    git config --global user.email "c@example.com" \
    && git config --global user.name "C H" \
    && git config --global pull.rebase false  # merge \
    && mkdir -p \
        /opt/ai-devops-worker/bin \
        /opt/ai-devops-worker/vscode-seed \
        /config/data \
        /config/extensions \
        /workspace

# install vscode extentions
COPY duplicated-files/vscode_snapshot_install_extensions.sh /opt/ai-devops-worker/bin/
COPY duplicated-files/vscode_extensions.txt                 /opt/ai-devops-worker/vscode-seed/vscode_extensions.txt
RUN chmod 755 /opt/ai-devops-worker/bin/vscode_snapshot_install_extensions.sh \
              /opt/ai-devops-worker/vscode-seed/vscode_extensions.txt \
    &&        /opt/ai-devops-worker/bin/vscode_snapshot_install_extensions.sh \
              /opt/ai-devops-worker/vscode-seed/vscode_extensions.txt

WORKDIR /workspace

