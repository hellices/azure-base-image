# Makefile for building and pushing multi-platform Docker images to GHCR

# Image configuration
IMAGE_NAME ?= azure-base-image
REGISTRY ?= ghcr.io
# GitHub repository owner (defaults to hellices)
REPO_OWNER ?= hellices
IMAGE_TAG ?= latest
FULL_IMAGE_NAME = $(REGISTRY)/$(REPO_OWNER)/$(IMAGE_NAME):$(IMAGE_TAG)

# Platform configuration
PLATFORMS ?= linux/amd64,linux/arm64

# Docker buildx builder name
BUILDER_NAME ?= multiplatform-builder

.PHONY: help
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: setup-buildx
setup-buildx: ## Setup Docker buildx for multi-platform builds
	@echo "Setting up Docker buildx..."
	@echo "Installing QEMU for multi-architecture support..."
	@docker run --rm --privileged multiarch/qemu-user-static --reset -p yes > /dev/null 2>&1 || true
	@if ! docker buildx ls | grep -q $(BUILDER_NAME); then \
		docker buildx create --name $(BUILDER_NAME) --use; \
	else \
		docker buildx use $(BUILDER_NAME); \
	fi
	@docker buildx inspect --bootstrap

.PHONY: build
build: setup-buildx ## Build multi-platform Docker image locally (amd64 only for local load)
	@echo "Building image for local use: $(FULL_IMAGE_NAME)"
	@echo "Note: Building for linux/amd64 only (multi-platform images can only be pushed, not loaded)"
	docker buildx build \
		--platform linux/amd64 \
		-t $(FULL_IMAGE_NAME) \
		--load \
		.

.PHONY: build-and-push
build-and-push: setup-buildx ## Build and push multi-platform Docker image to GHCR
	@echo "Building and pushing multi-platform image: $(FULL_IMAGE_NAME)"
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(FULL_IMAGE_NAME) \
		--push \
		.

.PHONY: login
login: ## Login to GitHub Container Registry (requires GITHUB_TOKEN or manual login)
	@if [ -z "$$GITHUB_TOKEN" ]; then \
		echo "GITHUB_TOKEN not set. Please login manually:"; \
		echo "  docker login ghcr.io"; \
	else \
		echo "Logging in to GHCR..."; \
		echo "$$GITHUB_TOKEN" | docker login ghcr.io -u $(REPO_OWNER) --password-stdin; \
	fi

.PHONY: push
push: ## Push the image to GHCR (requires prior build and login)
	@echo "Pushing image: $(FULL_IMAGE_NAME)"
	docker push $(FULL_IMAGE_NAME)

.PHONY: clean
clean: ## Remove buildx builder
	@echo "Removing buildx builder..."
	@docker buildx rm $(BUILDER_NAME) || true

.PHONY: test
test: ## Test the built image
	@echo "Testing image: $(FULL_IMAGE_NAME)"
	@docker run --rm $(FULL_IMAGE_NAME) bash -c "which mount.cifs && which kinit && echo 'Image test passed!'"
