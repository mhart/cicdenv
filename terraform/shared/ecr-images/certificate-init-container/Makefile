#!make

SHELL=/bin/bash

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

IMAGE_NAME=certificate-init-container
IMAGE_VERSION=latest

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')

github_repo=https://github.com/proofpoint/certificate-init-container.git
github_ref=0.7.0

help:
	@echo "Targets:"
	@echo "  build - build the $(IMAGE_NAME) docker image"
	@echo "  push  - upload the image to ECR"

build:
	if [[ ! -d "certificate-init-container" ]]; then  \
	    git clone "$(github_repo)";                   \
	else                                              \
	    git pull; git checkout "$(github_branch)";    \
	fi
	(cd "certificate-init-container"; docker build -t $(IMAGE_NAME) .)

push:
	$(eval AWS_ACCOUNT=$(shell aws --profile=$(AWS_PROFILE) sts get-caller-identity --query 'Account' --output text))
	$(eval ECR_URL=$(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com)
	$(eval IMAGE_REPO=$(014719181291).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME))

	# Tag for ECR push by tag
	docker tag "$(IMAGE_NAME):$(IMAGE_VERSION)" "$(ECR_URL)/$(IMAGE_NAME):$(IMAGE_VERSION)"

	# Push to ECR
	eval $$(aws --profile=$(AWS_PROFILE) --region $(AWS_REGION) ecr get-login --no-include-email)
	docker push "$(ECR_URL)/$(IMAGE_NAME):$(IMAGE_VERSION)"
