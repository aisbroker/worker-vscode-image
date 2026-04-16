# worker-vscode-image

OCI base image for worker-vsvode.

Public Docker image published via GitHub Actions to GitHub Container Registry.

## Image

```bash
docker pull ghcr.io/aisbroker/worker-vsvode-image:latest
```

## Tags

- `latest` from `main`
- `vX.Y.Z` from Git tags like `v1.2.3`
- semver aliases like `1.2` and `1`

## Publish a release

```bash
git tag v1.0.0
git push origin v1.0.0
```

## Local build

```bash
docker build -t worker-vsvode-image:local .
```
