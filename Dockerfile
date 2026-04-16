#
# OCI base image for worker-vscode.
#

FROM gitpod/openvscode-server:latest

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER root

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y \
        less \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN    date -u +"%Y-%m-%dT%H:%M:%S%:z" >>      /root/.worker-vscode-image-github-build-was-here \
    && mkdir -p                           /workspace \
    && date -u +"%Y-%m-%dT%H:%M:%S%:z" >> /workspace/.worker-vscode-image-github-build-was-here 

#NOT: USER openvscode-server

WORKDIR /workspace

