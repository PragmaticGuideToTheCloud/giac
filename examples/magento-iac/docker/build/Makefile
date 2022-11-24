GCP_PROJECT_ID      = gcp_project_id
PROJECT_NAME        = magento
PROJECT_VERSION     = v1.0.0
CONTAINER_REGISTRY  = eu.gcr.io

SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

export

.PHONY: all clean build push edit_app_version build-app

all: build push edit_app_version

build: \
	build-app \
	edit_app_version

push: \
	push-app

clean:
	-rm -rf $(SELF)/.cache/

build-app:
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-app:$(PROJECT_VERSION) \
	  -f app.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  .

push-app: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-app:$(PROJECT_VERSION)


edit_app_version:
	sed -i ""  -E s/PROJECT_VERSION\.\*/PROJECT_VERSION=$(PROJECT_VERSION)/g ./../test/.env \
	&& sed -i ""  -E s/appVersion\.\*/appVersion:\ $(PROJECT_VERSION)/g ./../../helm-chart/Chart.yaml \
	&& sed -i ""  -E s/tag:\ \.\*/tag:\ $(PROJECT_VERSION)/g ./../../helm/dev/dev1/values.yaml
