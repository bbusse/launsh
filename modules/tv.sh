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

    local r
    r=$(awk -F',' '/EXT/ {print $2}' "${pl_file}" | \
    vju --title "${title}" --type select --center-text --return-pos)

    local url
    url=$(awk '/,'"${r}"'/ {getline;print;}' "${pl_file}")

    # Check if mpv is running, if not, check and remove socket
    if ! pgrep mpv > /dev/null; then
        if [ -e "${runtime_dir}/${mpv_socket}" ]; then
            rm -f "${runtime_dir}/${mpv_socket}"
        fi
    fi

    if [ -e "${runtime_dir}/${mpv_socket}" ]; then
       echo "playlist-play-index ${r}" | socat - $"${runtime_dir}"/"$mpv_socket"
       exit 0
    fi

    mpv --input-ipc-server="${runtime_dir}"/"$mpv_socket" --playlist-start="${r}" --geometry="30%+2100+0" "${pl_url}"
}

tv_meta() {
    case "$1" in
        name)
            echo "tv"
            ;;
        description)
            echo "Display and control playlist streams with mpv. Allows selection and switching of streams."
            ;;
        *)
            echo "Usage: tv_meta [name|description]"
            ;;
    esac
}
