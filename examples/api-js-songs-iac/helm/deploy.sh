#!/usr/bin/env bash

HELM_DEPLOYMENT_NAME=api-js-songs

helm upgrade --install ${HELM_DEPLOYMENT_NAME} ../helm-chart -f values.yaml "$@"
