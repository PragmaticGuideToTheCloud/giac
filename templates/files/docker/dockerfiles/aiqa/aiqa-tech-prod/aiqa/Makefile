
SELF := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

HOSTNAME   = eu.gcr.io
PROJECT_ID = aiqa-next-02

AIQA_GIT_REMOTE ?= git@edugitlab.e1s.it:AIQA/AIQA.git
AIQA_GIT_BRANCH ?= master
AIQA_GIT_COMMIT  = $(shell git --git-dir=$(SELF)/.cache/AIQA/.git/ describe HEAD)

export

.PHONY: all build push clean \
		web web_push \
		api api_push \
		src

all: build

build: web api

push: web_push api_push

clean:
	-rm -rf $(SELF)/.cache/

web: web.Dockerfile src
	docker build \
	  -t $(HOSTNAME)/$(PROJECT_ID)/aiqa-$@:$(AIQA_GIT_COMMIT) \
	  -f $< $(SELF)/

web_push: web
	docker push $(HOSTNAME)/$(PROJECT_ID)/aiqa-$<:$(AIQA_GIT_COMMIT)

api: api.Dockerfile src
	docker build \
	  -t $(HOSTNAME)/$(PROJECT_ID)/aiqa-$@:$(AIQA_GIT_COMMIT) \
	  --build-arg COMMIT=$(AIQA_GIT_COMMIT) \
	  -f $< $(SELF)/

api_push: api
	docker push $(HOSTNAME)/$(PROJECT_ID)/aiqa-$<:$(AIQA_GIT_COMMIT)

src:
	# ensure proper git repo state
	install -d $(SELF)/.cache/AIQA/ && cd $(SELF)/.cache/AIQA/ \
	&& git clone --branch=$(AIQA_GIT_BRANCH) $(AIQA_GIT_REMOTE) . || ( \
	    git fetch origin $(AIQA_GIT_BRANCH) --tags \
	    && git checkout $(AIQA_GIT_BRANCH) \
	    && git clean -df \
	    && git reset --hard origin/$(AIQA_GIT_BRANCH) \
	)

# vim:ts=4:sw=4:noet:syn=make:
