GCP_PROJECT_ID      = gcp_project_id_12345
PROJECT_NAME        = api-js-songs
GIT_REMOTE          = git@github.com:PragmaticGuideToTheCloud/api-js-songs.git
GIT_BRANCH          = main
PROJECT_VERSION     = $(shell git --git-dir=$(SELF)/.cache/$(PROJECT_NAME)/.git/ describe HEAD)
CONTAINER_REGISTRY  = eu.gcr.io

SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

export

.PHONY: all clean src build push edit_app_version build-traefik build-backend build-frontend

all: src build push edit_app_version

build: \
	build-traefik \
	build-backend \
	build-frontend \
	edit_app_version

push: \
	push-traefik \
	push-backend \
	push-frontend

clean:
	-rm -rf $(SELF)/.cache/

build-traefik: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-traefik:$(PROJECT_VERSION) \
	  -f traefik.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="" \
	  .

push-traefik: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-traefik:$(PROJECT_VERSION)

build-backend: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend:$(PROJECT_VERSION) \
	  -f backend.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="/backend" \
	  .

push-backend: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend:$(PROJECT_VERSION)

build-frontend: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-frontend:$(PROJECT_VERSION) \
	  -f frontend.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="/frontend" \
	  .

push-frontend: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-frontend:$(PROJECT_VERSION)

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
