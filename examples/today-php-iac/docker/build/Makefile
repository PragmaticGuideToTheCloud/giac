GCP_PROJECT_ID      = gcp_project_id_12345
PROJECT_NAME        = today-php
GIT_REMOTE          = git@github.com:PragmaticGuideToTheCloud/today-php.git
GIT_BRANCH          = main
PROJECT_VERSION     = $(shell git --git-dir=$(SELF)/.cache/$(PROJECT_NAME)/.git/ describe HEAD)
CONTAINER_REGISTRY  = eu.gcr.io

SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

export

.PHONY: all clean src build push edit_app_version build-web

all: src build push edit_app_version

build: \
	build-web \
	edit_app_version

push: \
	push-web

clean:
	-rm -rf $(SELF)/.cache/

build-web: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-web:$(PROJECT_VERSION) \
	  -f web.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="" \
	  .

push-web: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-web:$(PROJECT_VERSION)

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
	&& sed -i ""  -E s/tag:\ \.\*/tag:\ $(PROJECT_VERSION)/g ./../../helm/dev/dev1/values.yaml
