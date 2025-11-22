# Display playlist streams
# and open player with selection
# Switch stream if player is already streaming
# Dependencies: mpv
function tv() {
    local title
    title="${2}"
    local pl_url
    pl_url="${3}"
    local mpv_socket
    local pl_pos
    pl_pos=0
    mpv_socket="mpv-input"

    local p
    IFS='/' read -ra p <<< "${pl_url}"
    # Check XDG_RUNTIME_DIR, fall back to /tmp
    local runtime_dir
    if [ -z "$XDG_RUNTIME_DIR" ]; then
        runtime_dir="${HOME}/tmp"
    else
        runtime_dir="$XDG_RUNTIME_DIR"
    fi

    local pl_file
    pl_file="${runtime_dir}/$(basename -- "${pl_url}")"

    # --output-dir needs a new enough cURL
    cd "$runtime_dir" || exit 1
    if [ ! -f "$pl_file" ]; then curl -s -S --fail -O "$pl_url"; fi

    # Check if mpv is running, if not, check and remove socket
    if ! pgrep mpv > /dev/null; then
        # Remove stale socket file
        if [ -e "${runtime_dir}/${mpv_socket}" ]; then
            rm -f "${runtime_dir}/${mpv_socket}"
        fi
    else
        if [ -e "${runtime_dir}/${mpv_socket}" ]; then
        pl_pos=$(playlist_pos "${runtime_dir}/${mpv_socket}")
        pl_current_title=$(playlist_item_name "${runtime_dir}/${mpv_socket}")
        printf "Position: %s Item: %s\n" "${pl_pos}" "${pl_current_title}"
        fi
    fi

    local r
    r=$(awk -F',' '/EXT/ {print $2}' "${pl_file}" | \
    vju --title "${title}" --type select --center-text --return-pos --selected "${pl_current_title}")

    local url
    url=$(awk '/,'"${r}"'/ {getline;print;}' "${pl_file}")

    mpv --input-ipc-server="${runtime_dir}"/"$mpv_socket" --playlist-start="${r}" --geometry="30%+2100+0" "${pl_url}"
}

function playlist_pos() {
    local socket
    socket="${1}"
    local pos

    pos=$(echo '{ "command": ["get_property", "playlist-pos"] }' | socat - "${socket}")
    echo "${pos}" | jq -r '.data'
}

function playlist_item_name() {
    local socket
    socket="${1}"

    local title
    title=$(echo '{ "command": ["get_property", "media-title"] }' | socat - "${socket}")

    echo "${title}" | jq -r '.data'
}
