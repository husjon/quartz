#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.npm nodejs
# Note: replace shebang above with "#!/usr/bin/env bash" for non NixOS systems

cd "$(realpath "$(dirname "$0")")"

(
    set -e # Stop on error

    source ./lib/arg_parse.sh

    touch ~/.quartz_publish.env
    source ~/.quartz_publish.env

    # Pre-Publish hooks
    HOOKS_RUN_SUCCESSFULLY=true
    for f in ./publish.d/*; do
        echo "Running pre-publish hook: $f"
        ${f} 2>&1 || HOOKS_RUN_SUCCESSFULLY=false
        echo -e "\n\n"

        [[ "$HOOKS_RUN_SUCCESSFULLY" = false ]] && break
    done

    if [[ "$HOOKS_RUN_SUCCESSFULLY" = true ]]; then
        echo "Syncing ..."
        cd "${QUARTZ_PATH}"

        git diff

        echo "Press Enter to Sync or Ctrl+C to Cancel"
        read -r

        npx quartz sync
        echo -e "\n"
    else
        echo -e "Error during publish\n"
    fi
)

# Wait for Enter key to be pressed prior to exiting
echo "Press Enter to close"
read -r

# vim: sw=4
