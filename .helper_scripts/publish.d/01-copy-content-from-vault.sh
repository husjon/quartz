#!/usr/bin/env bash

set -e

test -z $QUARTZ_VAULT_PATH && echo "QUARTZ_VAULT_PATH not set" && exit 1
test -z $QUARTZ_PATH && echo "QUARTZ_PATH not set" && exit 1

rsync -av \
    --delete-before \
    "${VAULT_PATH}/" \
    "${QUARTZ_PATH}/content"
