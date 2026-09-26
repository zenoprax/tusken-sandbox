function tusken-opencode --description "Run an isolated instance of OpenCode with Podman"
    set -l project_dir (pwd)
    set -l project_name (basename $project_dir)
    set -l host_config "$HOME/.config/opencode/opencode.jsonc"
    set -l workspace /workspace
    podman run -it --rm \
        --name "sandbox-$project_name" \
        -v "$host_config:/root/.config/opencode/opencode.jsonc:ro" \
        -v "$project_dir:$workspace" \
        -e XDG_DATA_HOME="$workspace/.opencode/share" \
        -e XDG_STATE_HOME="$workspace/.opencode/state" \
        -w "$workspace" \
        ghcr.io/anomalyco/opencode:latest
end
