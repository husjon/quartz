export VAULT_PATH=""
export QUARTZ_PATH="$(realpath "$(dirname "$0")/..")"

check_path() {
    ls "$1" >/dev/null 2>&1

    if [[ $? -gt 0 ]]; then
        notify-send "arg_parse" "$2 ($1)"
        exit 1
    fi
}

while [[ $# -gt 0 ]]; do
    case "${1}" in
    --quartz-vault)
        VAULT_PATH=$(realpath "${2}")
        check_path "${VAULT_PATH}/../.obsidian" "Invalid Obsidian vault path"
        shift
        ;;
    --quartz-repo)
        QUARTZ_PATH=$(realpath "$2")
        check_path "${QUARTZ_PATH}/quartz.config.ts" "Invalid Quartz path"
        shift
        ;;
    esac
    shift # always shift at least once
done

# vim: sw=4
