#!/usr/bin/env bash

HELM_DEPLOYMENT_NAME=jenkins

helm upgrade --install ${HELM_DEPLOYMENT_NAME} ../helm-chart -f values.yaml "$@"
