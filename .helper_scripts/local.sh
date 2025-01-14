#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.npm nodejs
# Note: replace shebang above with "#!/usr/bin/env bash" for non NixOS systems

cd "$(realpath "$(dirname "$0")")"

source ./lib/arg_parse.sh

PID_FILE=/tmp/obsidian_quartz_local_server.pid

cleanup() {
    cd "${QUARTZ_PATH}"

    QUARTZ_PID=$(cat "${PID_FILE}" 2>/dev/null)
    kill ${QUARTZ_PID} >/dev/null 2>&1
    rm -f "${PID_FILE}"

    git checkout .
}

trap cleanup TERM INT

if [[ "$STOP_LOCAL_SERVER" = true ]]; then
    cleanup
    exit
fi

if [[ -f "${PID_FILE}" ]]; then
    cleanup
    sleep 3
fi

test -z $QUARTZ_VAULT_PATH && echo "QUARTZ_VAULT_PATH not set" && exit 1
test -z $QUARTZ_PATH && echo "QUARTZ_PATH not set" && exit 1

cd "${QUARTZ_PATH}"
rm -rf content/
ln -rsf "${QUARTZ_VAULT_PATH}/" "${QUARTZ_PATH}/content"

timeout --preserve-status 1h npx quartz build --serve &
QUARTZ_PID=$!
echo ${QUARTZ_PID} >"${PID_FILE}"

notify-send -u low "Quartz" "Starting local server"
sleep 3 # allow the server to start up before checking
_SERVER_STARTED=false
for i in {1..60}; do
    curl http://localhost:8080 --silent >/dev/null && _SERVER_STARTED=true && break
    sleep 1
done

if [[ "$_SERVER_STARTED" = true ]]; then
    notify-send "Quartz" "Started local server"

    if [[ "$OPEN_BROWSER" = true ]]; then
        xdg-open http://localhost:8080 >/dev/null 2>&1 &
    fi

    wait $QUARTZ_PID
    notify-send "Quartz" "Stopped local server"
else
    notify-send -u critical "Quartz" "Failed to start local server"
fi

# vim: sw=4
