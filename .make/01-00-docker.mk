# FYI:

# Naming convention for images is $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)
# e.g.                 docker.io/asapdotid/ansible:latest
# $(DOCKER_REGISTRY)   ---^        ^         ^              docker.io
# $(DOCKER_NAMESPACE)  ------------^         ^              asapdotid
# $(DOCKER_IMAGE_NAME) ----------------------^              ansible
# $(DOCKER_IMAGE_TAG)  ------------------------------^      latest

DOCKER_DIR:=${PWD}/src
DOCKER_BUILD_IMAGE_FILE:=$(DOCKER_DIR)/Dockerfile

ifeq ($(DOCKER_IMAGE_TAG),)
	TAG:=latest
else
	TAG:=$(DOCKER_IMAGE_TAG)
endif

# Run Build Docker Image
DOCKER_BUILD_COMMAND:= \
    docker buildx build \
    --build-arg BUILD_DATE=`date -u +”%Y-%m-%dT%H:%M:%SZ”` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    --build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
    --build-arg ANSIBLE_VERSION=$(ANSIBLE_VERSION) \
    -f $(DOCKER_BUILD_IMAGE_FILE) \
	-t $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/$(DOCKER_IMAGE_NAME):$(TAG) .

# Run Push Docker Image
DOCKER_PUSH_COMMAND:= \
	docker push $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/$(DOCKER_IMAGE_NAME):$(TAG)

##@ [Docker]

.PHONY: build
build: ## Docker build image with arguments VER="8.1" or with TAG=latest
	@$(DOCKER_BUILD_COMMAND)

.PHONY: push
push: ## Docker push image with arguments VER="8.1" or with TAG=latest
	@$(DOCKER_PUSH_COMMAND)
