#!/usr/bin/env bash

SUFFIX=iac

DIRS_AND_FILES_TO_CLEAN=(
    ansible
    auth
    db
    docker
    helm
    helm-chart
    ssh-keys
    terraform
    tests
    vpn
    README.md
)

EXAMPLES=(
    empty
    hello-cloud
    hello-ssh
    fantastic
    today-java
    today-js
    today-php
    today-python
    today-ruby
    api-java-poems
    api-ruby-proverbs
    api-php-quotations
    api-js-songs
    api-python-writers
    api-microservices
    geo-php-cities
    geo-js-deserts
    geo-ruby-lakes
    geo-java-mountains
    geo-python-rivers
    memorize-it
    redmine
    testlink
    jenkins
    magento
    airflow
)
