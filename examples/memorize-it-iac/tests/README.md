# Tests for terraform-ed infra

## 1. Installation

Install deps:

    pip3 install -r requirements.txt

## 2. Update the list of terraform dirs to be tested

    ./tests/find.sh

## 3. Run all the tests

    cd tests
    pytest -n 4 tests/*
