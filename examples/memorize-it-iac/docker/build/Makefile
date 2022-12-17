GCP_PROJECT_ID      = gcp_project_id_12345
PROJECT_NAME        = memorize-it
GIT_REMOTE          = git@github.com:gajdaw-teaching/memorize-it.git
GIT_BRANCH          = main
PROJECT_VERSION     = $(shell git --git-dir=$(SELF)/.cache/$(PROJECT_NAME)/.git/ describe HEAD)
CONTAINER_REGISTRY  = eu.gcr.io

SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

export

.PHONY: all clean src build push edit_app_version build-php

all: src build push edit_app_version

build: \
	build-php \
	edit_app_version

push: \
	push-php

clean:
	-rm -rf $(SELF)/.cache/

build-php: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-php:$(PROJECT_VERSION) \
	  -f php.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="" \
	  .

push-php: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-php:$(PROJECT_VERSION)

src:
	install -d $(SELF)/.cache/$(PROJECT_NAME)/ && cd $(SELF)/.cache/$(PROJECT_NAME)/ \
	&& git clone --branch=$(GIT_BRANCH) $(GIT_REMOTE) . || ( \
	    git fetch origin $(GIT_BRANCH) --tags \
	    && git checkout $(GIT_BRANCH) \
	    && git clean -df \
	    && git reset --hard origin/$(GIT_BRANCH) \
	)

edit_app_version: src
	sed -i ""  -E s/PROJECT_VERSION\.\*/PROJECT_VERSION=$(PROJECT_VERSION)/g ./../test/.env \
	&& sed -i ""  -E s/appVersion\.\*/appVersion:\ $(PROJECT_VERSION)/g ./../../helm-chart/Chart.yaml \
	&& sed -i ""  -E s/tag:\ \.\*/tag:\ $(PROJECT_VERSION)/g ./../../helm/values.yaml \
	&& sed -i ""  -E "s/  version:\ \.\*/  version:\ $(PROJECT_VERSION)/g" ./../../iac.yaml
