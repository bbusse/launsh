info() {
    if [ "info" == "${log_level}" ]; then
        echo "${@}" >&2
        logger -p user.notice -t "${SCRIPT_NAME}" "${@}"
    fi
}

error() {
    echo -e "\033[0;31m${*}\033[0m" >&2
    logger -p user.error -t "${SCRIPT_NAME}" "${@}"
}

# Cross-platform clipboard paste
cmd_paste() {
    if [[ "$(uname)" == "Linux" ]]; then
        wl-paste
    elif [[ "$(uname)" == "Darwin" ]]; then
        pbpaste
    else
        echo "Clipboard paste not supported on this OS" >&2
        return 1
    fi
}

info_with_notify() {
    info "${@}"

    if [ "1" = "${LAUNSH_SEND_NOTIFICATION}" ]; then
        if ! notify-send -t 6000 "${1}"; then
            error "$(printf "Failed to send notification\n")"
        fi
    fi
}

# Cross-platform clipboard copy
cmd_copy() {
    local c
    c="${1}"

    if [[ "$(uname)" == "Linux" ]]; then
        wl-copy
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "${c}" | pbcopy
    else
        echo "Clipboard copy not supported on this OS" >&2
        return 1
    fi
}

ask_pass() {
    echo "" | vju -c "${HOME}/.config/vju/config-input" | cmd_copy
}

clear_clipboard() {
    wl-copy --clear
}

launch_privileged() {
    wl-paste | sudo -S bash -c "launsh ${@}"
}

sql_exec() {
    local file
    file="${1}"
    local sql
    sql="${2}"

    local r
    r="$(sqlite3 "${file}" "${sql}")"
    printf "%s\n" "${r}"
}

# ytfzf uses this function if defined
handle_display_img() {
    9 page "${1}"
}

# Use XDG or plan9 plumbing to open files
# with an appropriate application
plumb_open() {
    case "${LAUNSH_OPEN}" in
        '9')
            9 page "${1}"
            ;;
        'xdg')
            xdg-open "${1}"
            ;;
    esac
}

open_browser() {
    local url
    url="${1}"
    local profile
    profile="${2}"

    local browser
    browser="firefox"

    if command -v firefox &>/dev/null; then
        browser="firefox"
    elif [ -x "/Applications/Firefox.app/Contents/MacOS/firefox" ]; then
        browser="/Applications/Firefox.app/Contents/MacOS/firefox"
    else
        error "No Firefox executable found\n" >&2
        return 1
    fi

    if [ -n "${profile}" ]; then
        "${browser}" --new-tab --profile "${profile}" "${url}" &>/dev/null &
    else
        "${browser}" --new-tab "${url}" &>/dev/null &
    fi
}
