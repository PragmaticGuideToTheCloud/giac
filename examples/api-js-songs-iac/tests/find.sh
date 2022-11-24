#!/usr/bin/env bash

# The script finds all the directories
# containing terraform/terragrunt code
# in which we need to run:
#
#    terragrunt plan
#
# command.
#

# The script find.sh will be invoked from two different locations:
# - from root dir of this repo (in GitHub Action)
# - tests/ dir (local run)
SELF=$(realpath "$0" | xargs dirname) && cd $SELF/
cd ..

find terraform -name "terragrunt.hcl" | \
  grep -v "/.terragrunt-cache/" | \
  sed -E s/^terraform\\/terragrunt.hcl//g |
  sed -E s/\\/terragrunt.hcl//g |
  sed '/^$/d' |
  sort |
  uniq > tests/tests/dirs.txt
