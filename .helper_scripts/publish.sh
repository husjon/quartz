#!/bin/bash

set -e  # Exit on Error

(
    export BASE_DIR="$(dirname "$(realpath "$0")")"
    export QUARTZ_FOLDER="$(realpath ${BASE_DIR}/..)"

    touch ~/.quartz_publish.env
    source ~/.quartz_publish.env

    # Pre-Publish hooks
    cd "${BASE_DIR}" || exit 1
    for f in ./publish.d/*; do
        echo "Running pre-publish hook: $f"
        ${f} 2>&1
        echo
    done

    cd "${QUARTZ_FOLDER}" || exit 1

    npx quartz sync || read -r
) > /tmp/quartz_pulish.log
