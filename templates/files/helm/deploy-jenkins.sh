#!/usr/bin/env bash

HELM_DEPLOYMENT_NAME=jenkins

helm repo add jenkins https://charts.jenkins.io
helm repo update

helm upgrade --install ${HELM_DEPLOYMENT_NAME} jenkins/jenkins -f values.yaml

#Credentials:
#
#    username: admin
#
#Password:
#
#    kubectl exec --namespace default -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
