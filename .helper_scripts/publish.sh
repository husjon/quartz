#!/bin/bash

export BASE_DIR="$(dirname "$(realpath "$0")")"
export QUARTZ_FOLDER="$(realpath ${BASE_DIR}/..)"

cd "${QUARTZ_FOLDER}" || exit 1

npx quartz sync || read -r
