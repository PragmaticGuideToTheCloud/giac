
SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

HOSTNAME   = eu.gcr.io
PROJECT_ID = aiqa-next-02

AIQA_ML_CLUSTER_GIT_REMOTE ?= git@edugitlab.e1s.it:AIQA/aiqa-ml-cluster.git
AIQA_ML_CLUSTER_GIT_BRANCH ?= master
AIQA_ML_CLUSTER_GIT_COMMIT  = $(shell git --git-dir=$(SELF)/.cache/aiqa-ml-cluster/.git/ describe HEAD)

export

.PHONY: all build push clean \
		api api_push \
		worker worker_push \
		src

all: build

build: api worker

push: api_push worker_push

clean:
	-rm -rf $(SELF)/.cache/

api: api.Dockerfile src
	docker build \
	  -t $(HOSTNAME)/$(PROJECT_ID)/aiqa-ml-cluster-$@:$(AIQA_ML_CLUSTER_GIT_COMMIT) \
	  --build-arg COMMIT=$(AIQA_ML_CLUSTER_GIT_COMMIT) \
	  -f $< $(SELF)/

api_push: api
	docker push $(HOSTNAME)/$(PROJECT_ID)/aiqa-ml-cluster-$<:$(AIQA_ML_CLUSTER_GIT_COMMIT)

worker: worker.Dockerfile src
	docker build \
	  -t $(HOSTNAME)/$(PROJECT_ID)/aiqa-ml-cluster-$@:$(AIQA_ML_CLUSTER_GIT_COMMIT) \
	  -f $< $(SELF)/

worker_push: worker
	docker push $(HOSTNAME)/$(PROJECT_ID)/aiqa-ml-cluster-$<:$(AIQA_ML_CLUSTER_GIT_COMMIT)

src:
	# ensure proper git repo state
	install -d $(SELF)/.cache/aiqa-ml-cluster/ && cd $(SELF)/.cache/aiqa-ml-cluster/ \
	&& git clone --branch=$(AIQA_ML_CLUSTER_GIT_BRANCH) $(AIQA_ML_CLUSTER_GIT_REMOTE) . || ( \
	    git fetch origin $(AIQA_ML_CLUSTER_GIT_BRANCH) --tags \
	    && git checkout $(AIQA_ML_CLUSTER_GIT_BRANCH) \
	    && git clean -df \
	    && git reset --hard origin/$(AIQA_ML_CLUSTER_GIT_BRANCH) \
	)

# vim:ts=4:sw=4:noet:syn=make:
