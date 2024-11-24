export OBSIDIAN_VAULT_PATH=""
export QUARTZ_VAULT_PATH=""
export QUARTZ_PATH="$(realpath "$(dirname "$0")/..")"
export OPEN_BROWSER=false
export STOP_LOCAL_SERVER=false

check_path() {
    ls "$1" >/dev/null 2>&1

    if [[ $? -gt 0 ]]; then
        notify-send "arg_parse" "$2 ($1)"
        exit 1
    fi
}

while [[ $# -gt 0 ]]; do
    case "${1}" in
    --obsidian-vault)
        OBSIDIAN_VAULT_PATH=$(realpath "${2}")
        check_path "${OBSIDIAN_VAULT_PATH}/.obsidian" "Invalid Obsidian vault path"
        shift
        ;;
    --quartz-vault)
        QUARTZ_VAULT_PATH=$(realpath "${2}")
        check_path "${QUARTZ_VAULT_PATH}" "Invalid Quartz vault path"
        shift
        ;;
    --quartz-repo)
        QUARTZ_PATH=$(realpath "$2")
        check_path "${QUARTZ_PATH}/quartz.config.ts" "Invalid Quartz path"
        shift
        ;;
    --browser)
        OPEN_BROWSER=true
        ;;
    --stop-server)
        STOP_LOCAL_SERVER=true
        ;;
    esac
    shift # always shift at least once
done

# vim: sw=4
