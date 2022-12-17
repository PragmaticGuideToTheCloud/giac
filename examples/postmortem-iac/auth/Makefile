GCP_PROJECT_ID = gcp_project_id_12345
REGION         = europe-west1
ZONE           = europe-west1-b
CLUSTER_NAME   = postmortem-prod

export

.PHONY: all \
        auth \
        check \
        configure-docker \
        info \
        init \
        kubeconfig \
        login \
        logout \
        set-project \
        setup-project

all: init setup-project

init: check logout auth

auth: check login application-default set-project configure-docker

setup-project: set-project

check:
	@if [[ "$(GCP_PROJECT_ID)" = gcp_project_id_* ]]; then \
	    echo "ERROR: Please provide correct GCP_PROJECT_ID!"; \
	    exit 1; \
	fi >&2

logout:
	gcloud config unset project
	gcloud config unset account
	gcloud auth revoke --all || true

# necessary to run make kubeconfig
login:
	gcloud auth login

# necessary to access bucket
application-default:
	gcloud auth application-default login

info:
	echo $(GCP_PROJECT_ID) && gcloud auth list && gcloud config list project

set-project: check
	gcloud config set project $(GCP_PROJECT_ID)

configure-docker:
	gcloud auth configure-docker

kubeconfig:
	gcloud container clusters get-credentials $(CLUSTER_NAME) --zone=$(ZONE) --project=$(GCP_PROJECT_ID)

kubeconfigRegion:
	gcloud container clusters get-credentials $(CLUSTER_NAME) --region=$(REGION) --project=$(GCP_PROJECT_ID)
