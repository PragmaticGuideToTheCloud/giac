#!/usr/bin/env bash

HELM_DEPLOYMENT_NAME=redmine

helm upgrade --install ${HELM_DEPLOYMENT_NAME} ../../../helm-chart -f values.yaml "$@"
