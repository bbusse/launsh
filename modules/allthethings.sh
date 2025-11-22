function allthethings() {
    local modules_list
    modules_list=$(list_modules | while read -r mod; do
        first="${mod:0:1}"
        rest="${mod:1}"
        printf "%s%s\n" "$(echo "$first" | tr '[:lower:]' '[:upper:]')" "$rest"
    done)

    local r
    r=$(printf "%s\n" "${modules_list}" | vju --title "All The Things" --type select --center-text)
}
