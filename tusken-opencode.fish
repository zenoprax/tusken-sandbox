function tusken-opencode --description "Run an isolated instance of OpenCode with Podman"
    set -l workspace /workspace
    set -l PROJ_DIR (pwd)
    set -l PROJ_NAME (basename "$PROJ_DIR")
    set PROJ_HASH (printf '%s' "$PROJ_DIR" | sha256sum | cut -c1-6)
    set POD_NAME "sandbox-$PROJ_NAME-$PROJ_HASH"
    podman run -it --rm --pull newer --userns=keep-id \
        --name "$POD_NAME" \
        --hostname "$POD_NAME" \
        --secret openrouter_api_key,type=env,target=OPENROUTER_API_KEY \
        -v "$XDG_CONFIG_HOME/opencode:/etc/opencode:ro" \
        -e HOME="$workspace/$PROJ_NAME/.opencode/home" \
        -v "$PROJ_DIR:$workspace/$PROJ_NAME" \
        -w "$workspace/$PROJ_NAME" \
        ghcr.io/zenoprax/tusken-sandbox:main
end
