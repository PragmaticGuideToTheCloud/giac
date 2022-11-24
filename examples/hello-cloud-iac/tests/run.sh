#!/usr/bin/env bash

set -x

# find all terraform dirs
./find.sh

# run all GREEN tests
pytest -n 5 tests/*.py

exit $?
