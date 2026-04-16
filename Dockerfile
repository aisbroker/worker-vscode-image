#
# OCI base image for worker-vscode.
#

FROM gitpod/openvscode-server:latest

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        less \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#NOT: USER openvscode-server

WORKDIR /workspace

