
SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

HOSTNAME   = eu.gcr.io
PROJECT_ID = aiqa-next-02

AIQA_GIT_COMMIT            = $(shell git --git-dir=$(SELF)/aiqa/.cache/AIQA/.git/ describe HEAD)
AIQA_ML_CLUSTER_GIT_COMMIT = $(shell git --git-dir=$(SELF)/aiqa-ml-cluster/.cache/aiqa-ml-cluster/.git/ describe HEAD)

export

.PHONY: all build push \
        build_aiqa \
        build_aiqa_ml_cluster \
        push_aiqa \
        push_aiqa_ml_cluster \
        clean

all: build

build: build_aiqa build_aiqa_ml_cluster

push: push_aiqa push_aiqa_ml_cluster
	@echo AIQA_GIT_COMMIT = $(AIQA_GIT_COMMIT)
	@echo AIQA_ML_CLUSTER_GIT_COMMIT = $(AIQA_ML_CLUSTER_GIT_COMMIT)

build_aiqa:
	cd aiqa/ && make build

build_aiqa_ml_cluster:
	cd aiqa-ml-cluster/ && make build

push_aiqa: build_aiqa
	cd aiqa/ && make push

push_aiqa_ml_cluster: build_aiqa_ml_cluster
	cd aiqa-ml-cluster/ && make push

clean:
	-rm -rf aiqa/.cache/
	-rm -rf aiqa-ml-cluster/.cache/

# vim:ts=4:sw=4:noet:syn=make:
