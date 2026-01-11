# launsh meta menu
function allthethings() {
    local modules_list

    modules_list=($(list_modules | while read -r mod; do
        first="${mod:0:1}"
        rest="${mod:1}"
        name="$(echo "$first" | tr '[:lower:]' '[:upper:]')$rest"
        if [[ "$name" != "Lib" && "$name" != "Allthethings" ]]; then
            printf "%s\n" "$name"
        fi
    done))

    local r
    r=$(printf "%s\n" "${modules_list[@]}" | vju --title "All The Things" --type select --center-text)

    launsh "${r}"
}
