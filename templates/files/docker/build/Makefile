GCP_PROJECT_ID      = <<< provider.gcp.project_id >>>
PROJECT_NAME        = <<< name >>>
GIT_REMOTE          = <<< app_repo >>>
GIT_BRANCH          = main
PROJECT_VERSION     = $(shell git --git-dir=$(SELF)/.cache/$(PROJECT_NAME)/.git/ describe HEAD)
CONTAINER_REGISTRY  = <<< container_registry >>>

SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

export

.PHONY: all clean src build push edit_app_version<% for container in containers %> build-<<< container.name >>><% if not loop.last %><% endif %><% endfor %>

all: src build push edit_app_version

build: \
<%- for container in containers %>
	build-<<< container.name >>> \
<%- endfor %>
	edit_app_version

push: \
<%- for container in containers %>
	push-<<< container.name >>><% if not loop.last %> \<% endif %>
<%- endfor %>

clean:
	-rm -rf $(SELF)/.cache/
<% for container in containers %>
build-<<< container.name >>>: src
	docker build \
	  -t $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-<<< container.name >>>:$(PROJECT_VERSION) \
	  -f <<< container.name >>>.Dockerfile \
	  --build-arg PROJECT_NAME=$(PROJECT_NAME) \
	  --build-arg SRC_CODE_DIR="<<< container.srcCodePath >>>" \
	  .

push-<<< container.name >>>: build
	docker push $(CONTAINER_REGISTRY)/$(GCP_PROJECT_ID)/$(PROJECT_NAME)-<<< container.name >>>:$(PROJECT_VERSION)
<% endfor %>
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
