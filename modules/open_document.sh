# Open recent document from given path
function open_document() {
    local title
    title="${2}"
    local path
    path="${3}"
    local nitems
    nitems="${4}"
    local reexec
    reexec="${5}"
    local prev_item
    prev_item="${6}"

    # Do not reexec by default
    if [ -z "$reexec" ]; then reexec=0; fi

    cd "${path}" || exit 1

    local r

    if [ -z "$nitems" ]; then nitems=-1; fi

    if [ "$nitems" -gt "0" ]; then
        if [ -z "$prev_item" ]; then
            r=$(ls -d1t * | head -n"${nitems}" | vju --title "${title}" --type select --center-text)
        else
            r=$(ls -d1t * | head -n"${nitems}" | vju --title "${title}" --type select --center-text --selected "${prev_item}")
        fi
    else
        if [ -z "$prev_item" ]; then
            r=$(ls -d1t * | vju --title "${title}" --width=700 --type select --center-text)
        else
            r=$(ls -d1t * | vju --title "${title}" --width=700 --type select --center-text --selected "${prev_item}")
        fi
    fi

    plumb_open "$r"

    if ! [ -z "${r}" ]; then
        launsh open-document "" "${path}" "${nitems}" 1 "${r}"
    fi
}
