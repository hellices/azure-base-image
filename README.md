# Azure Base Image

A lightweight Ubuntu-based Docker image with CIFS and Kerberos support for Azure file share mounting.

## Features

- Ubuntu 20.04 base
- CIFS utilities for SMB/CIFS mounting
- Kerberos authentication support
- Multi-platform support (amd64, arm64)

## Packages Included

- `cifs-utils`: Tools for mounting CIFS/SMB shares
- `keyutils`: Kernel key management utilities
- `krb5-user`: Kerberos authentication client
- `samba-common-bin`: Common Samba utilities

## Building the Image

### Prerequisites

- Docker with buildx support (Docker 19.03+)
- Make

### Building Multi-Platform Image

Build the image for multiple platforms:

```bash
make build
```

### Building and Pushing to GHCR

First, login to GitHub Container Registry:

```bash
# Option 1: Using GITHUB_TOKEN environment variable
export GITHUB_TOKEN=your_github_token
make login

# Option 2: Manual login
docker login ghcr.io
```

Then build and push:

```bash
make build-and-push
```

### Customizing Build

You can customize the build using environment variables:

```bash
# Custom image name
IMAGE_NAME=my-custom-image make build

# Custom tag
IMAGE_TAG=v1.0.0 make build-and-push

# Custom repository owner
REPO_OWNER=myusername make build-and-push

# Custom platforms
PLATFORMS=linux/amd64 make build
```

### Available Make Targets

- `help`: Show all available targets
- `setup-buildx`: Setup Docker buildx for multi-platform builds
- `build`: Build multi-platform Docker image
- `build-and-push`: Build and push multi-platform image to GHCR
- `login`: Login to GitHub Container Registry
- `push`: Push the image to GHCR
- `test`: Test the built image
- `clean`: Remove buildx builder

## Usage

Pull the image from GHCR:

```bash
docker pull ghcr.io/hellices/azure-base-image:latest
```

Run the container:

```bash
docker run -it ghcr.io/hellices/azure-base-image:latest
```

## License

This project is open source and available under the MIT License.
