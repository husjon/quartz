#!/usr/bin/env bash

rsync -av \
    "${OBSIDIAN_VAULT_FOLDER}/0. Quartz/" \
    "${QUARTZ_FOLDER}/content/"
