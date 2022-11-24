#!/usr/bin/env bash

set -e

. examples.sh

function runCleanupExamples() {
    for ex in "${EXAMPLES[@]}"
    do
        echo "--->" $ex
        for item in "${DIRS_AND_FILES_TO_CLEAN[@]}"
        do
            rm -rf examples/${ex}-${SUFFIX}/${item}
        done
    done
}

runCleanupExamples
