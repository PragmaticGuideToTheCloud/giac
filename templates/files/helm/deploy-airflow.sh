#!/usr/bin/env bash

HELM_DEPLOYMENT_NAME=airflow

helm repo add airflow-stable https://airflow-helm.github.io/charts
helm repo update

helm upgrade --install ${HELM_DEPLOYMENT_NAME} airflow-stable/airflow -f values.yaml
