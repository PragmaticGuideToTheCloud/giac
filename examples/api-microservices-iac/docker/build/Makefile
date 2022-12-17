GCP_PROJECT_ID      = gcp_project_id_12345
PROJECT_NAME        = api-microservices
GIT_REMOTE          = git@github.com:PragmaticGuideToTheCloud/api-microservices.git
GIT_BRANCH          = main
PROJECT_VERSION     = $(shell git --git-dir=$(SELF)/.cache/$(PROJECT_NAME)/.git/ describe HEAD)
CONTAINER_REGISTRY  = eu.gcr.io

SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

export

.PHONY: all clean src build push edit_app_version build-traefik build-backend-django build-backend-java build-backend-node build-backend-ruby build-backend-symfony build-fpm build-frontend

all: src build push edit_app_version

build: \
	build-traefik \
	build-backend-django \
	build-backend-java \
	build-backend-node \
	build-backend-ruby \
	build-backend-symfony \
	build-fpm \
	build-frontend \
	edit_app_version

push: \
	push-traefik \
	push-backend-django \
	push-backend-java \
	push-backend-node \
	push-backend-ruby \
	push-backend-symfony \
	push-fpm \
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

build-backend-django: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-django:$(PROJECT_VERSION) \
	  -f backend-django.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="/backend-django" \
	  .

push-backend-django: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-django:$(PROJECT_VERSION)

build-backend-java: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-java:$(PROJECT_VERSION) \
	  -f backend-java.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="/backend-java" \
	  .

push-backend-java: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-java:$(PROJECT_VERSION)

build-backend-node: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-node:$(PROJECT_VERSION) \
	  -f backend-node.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="/backend-node" \
	  .

push-backend-node: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-node:$(PROJECT_VERSION)

build-backend-ruby: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-ruby:$(PROJECT_VERSION) \
	  -f backend-ruby.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="/backend-ruby" \
	  .

push-backend-ruby: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-ruby:$(PROJECT_VERSION)

build-backend-symfony: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-symfony:$(PROJECT_VERSION) \
	  -f backend-symfony.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="/backend-symfony" \
	  .

push-backend-symfony: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-backend-symfony:$(PROJECT_VERSION)

build-fpm: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-fpm:$(PROJECT_VERSION) \
	  -f fpm.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="/backend-symfony" \
	  .

push-fpm: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-fpm:$(PROJECT_VERSION)

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
	&& sed -i ""  -E s/tag:\ \.\*/tag:\ $(PROJECT_VERSION)/g ./../../helm/values.yaml \
	&& sed -i ""  -E "s/  version:\ \.\*/  version:\ $(PROJECT_VERSION)/g" ./../../iac.yaml
