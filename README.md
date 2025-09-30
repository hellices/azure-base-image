# Azure Base Image

This repository contains a Docker base image with CIFS and Kerberos authentication support.

## Image Contents

The image is based on Ubuntu 20.04 and includes:
- `cifs-utils` - CIFS filesystem utilities
- `keyutils` - Key management utilities
- `krb5-user` - Kerberos client tools
- `samba-common-bin` - Samba common binaries

## Supported Architectures

This image supports multiple architectures:
- `linux/amd64` - AMD64/x86_64
- `linux/arm64` - ARM64/aarch64

## GitHub Container Registry

The Docker image is automatically built and pushed to GitHub Container Registry (GHCR) via GitHub Actions.

### Image Location

The image is available at:
```
ghcr.io/hellices/azure-base-image:latest
```

### Available Tags

- `latest` - Latest build from the main branch
- `main` - Latest build from the main branch
- `sha-<commit>` - Build from a specific commit
- `pr-<number>` - Build from a pull request (not pushed to registry)

### Using the Image

Pull the image:
```bash
docker pull ghcr.io/hellices/azure-base-image:latest
```

Run a container:
```bash
docker run -it ghcr.io/hellices/azure-base-image:latest
```

To pull a specific architecture:
```bash
docker pull --platform linux/amd64 ghcr.io/hellices/azure-base-image:latest
docker pull --platform linux/arm64 ghcr.io/hellices/azure-base-image:latest
```

## Build Workflow

The image is built automatically on:
- Push to the `main` branch
- Pull requests to the `main` branch (build only, not pushed)
- Manual workflow dispatch

### Manual Trigger

You can manually trigger a build from the Actions tab in the GitHub repository.

## Local Development

Build the image locally:
```bash
docker build -t azure-base-image .
```

Run locally:
```bash
docker run -it azure-base-image
```
