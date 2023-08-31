#!/bin/bash

BASE_DIR="$(realpath "$(dirname "$0")")"
QUARTZ_FOLDER="${BASE_DIR}/.."

ARGS=${1:-""}

PID_FILE=/tmp/obsidian_quartz_local_server.pid
LOCAL_QUARTZ_PID_FILE="${PID_FILE}.hugo"
LOCAL_QUARTZ_PID=0


while [[ -f "${LOCAL_QUARTZ_PID_FILE}" ]]; do
    LOCAL_QUARTZ_PID=$(cat "${LOCAL_QUARTZ_PID_FILE}")
    kill "${LOCAL_QUARTZ_PID}"
    sleep 0.5
done

if [[ ! -f "${PID_FILE}" ]]; then
    trap 'kill ${LOCAL_QUARTZ_PID}' TERM INT
    trap 'rm "${PID_FILE}"; rm "${LOCAL_QUARTZ_PID_FILE}"' EXIT

    cd "${QUARTZ_FOLDER}" || exit 1

    timeout --preserve-status 1h npx quartz build --serve &
    LOCAL_QUARTZ_PID=$!
    echo "${LOCAL_QUARTZ_PID}" > "${LOCAL_QUARTZ_PID_FILE}"

    echo $$ > "${PID_FILE}"

    case $ARGS in
        browser)
            for i in {1..10}; do
                curl localhost:8080 --silent > /dev/null && break
                sleep 1;
            done

            notify-send "Quartz" "Started local server"
            xdg-open http://localhost:8080 &
        ;;
    esac

    wait "${LOCAL_QUARTZ_PID}" && \
        notify-send "Quartz" "Stopped local server"
fi
