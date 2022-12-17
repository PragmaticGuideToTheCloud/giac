#!/usr/bin/env bash

HELM_DEPLOYMENT_NAME=geo-java-mountains

helm upgrade --install ${HELM_DEPLOYMENT_NAME} ../helm-chart -f values.yaml "$@"
