
MAINTAINER ?= gajdaw@gajdaw.pl
VERSION    ?= $(shell git rev-parse --short HEAD)

HOSTNAME   ?= eu.gcr.io
PROJECT_ID ?= <<< provider.gcp.project_id >>>

PHP_VERSION    ?= 7.3.7
PYTHON_VERSION ?= 3.7.4
NODE_VERSION   ?= 10.16.3

NGINX_VERSION_APT ?= 1.17.0-1
TINI_VERSION      ?= 0.18.0

DOCKER_CE_VERSION_APT  ?= 18.06.3~ce~3-0
DOCKER_COMPOSE_VERSION ?= 1.24.1

export

.PHONY: all build push clean gcloud

all: build

build: bionic64_php_python_tensorflow_nginx \
       bionic64_php_python_node_yarn_docker \
       bionic64_node_yarn_nginx

push: bionic64_php_python_tensorflow_nginx_push \
      bionic64_php_python_node_yarn_docker_push \
      bionic64_node_yarn_nginx_push

clean:
	-docker rmi $(shell docker images --format '{{.Repository}}:{{.Tag}}' | grep bionic64_php_python_tensorflow_nginx:$(VERSION))
	-docker rmi $(shell docker images --format '{{.Repository}}:{{.Tag}}' | grep bionic64_php_python_node_yarn_docker:$(VERSION))
	-docker rmi $(shell docker images --format '{{.Repository}}:{{.Tag}}' | grep bionic64_node_yarn_nginx:$(VERSION))

gcloud:
	gcloud auth configure-docker

.PHONY: bionic64_php_python_tensorflow_nginx \
        bionic64_php_python_tensorflow_nginx_push

bionic64_php_python_tensorflow_nginx: bionic64_php_python_tensorflow_nginx/Dockerfile
	docker build \
	  -t $(HOSTNAME)/$(PROJECT_ID)/$@:$(VERSION) \
	  --build-arg PHP_VERSION=$(PHP_VERSION) \
	  --build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
	  --build-arg NGINX_VERSION_APT=$(NGINX_VERSION_APT) \
	  --build-arg TINI_VERSION=$(TINI_VERSION) \
	  -f $< $@/

bionic64_php_python_tensorflow_nginx_push: bionic64_php_python_tensorflow_nginx
	docker push $(HOSTNAME)/$(PROJECT_ID)/$<:$(VERSION)

.PHONY: bionic64_php_python_node_yarn_docker \
        bionic64_php_python_node_yarn_docker_push

bionic64_php_python_node_yarn_docker: bionic64_php_python_node_yarn_docker/Dockerfile
	docker build \
	  -t $(HOSTNAME)/$(PROJECT_ID)/$@:$(VERSION) \
	  --build-arg PHP_VERSION=$(PHP_VERSION) \
	  --build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
	  --build-arg NODE_VERSION=$(NODE_VERSION) \
	  --build-arg TINI_VERSION=$(TINI_VERSION) \
	  --build-arg DOCKER_CE_VERSION_APT=$(DOCKER_CE_VERSION_APT) \
	  --build-arg DOCKER_COMPOSE_VERSION=$(DOCKER_COMPOSE_VERSION) \
	  -f $< $@/

bionic64_php_python_node_yarn_docker_push: bionic64_php_python_node_yarn_docker
	docker push $(HOSTNAME)/$(PROJECT_ID)/$<:$(VERSION)

.PHONY: bionic64_node_yarn_nginx \
        bionic64_node_yarn_nginx_push

bionic64_node_yarn_nginx: bionic64_node_yarn_nginx/Dockerfile
	docker build \
	  -t $(HOSTNAME)/$(PROJECT_ID)/$@:$(VERSION) \
	  --build-arg NODE_VERSION=$(NODE_VERSION) \
	  --build-arg NGINX_VERSION_APT=$(NGINX_VERSION_APT) \
	  --build-arg TINI_VERSION=$(TINI_VERSION) \
	  -f $< $@/

bionic64_node_yarn_nginx_push: bionic64_node_yarn_nginx
	docker push $(HOSTNAME)/$(PROJECT_ID)/$<:$(VERSION)

# vim:ts=4:sw=4:noet:syn=make:
