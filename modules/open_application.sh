# Launsh application
function open() {
    # Get all unique executable names in PATH
    commands=$(IFS=:; for dir in $PATH; do
        [ -d "$dir" ] && find "$dir" -maxdepth 1 -type f -perm -111 2>/dev/null
    done | awk -F/ '{print $NF}' | sort -u)
    printf "%s\n" $commands | vju --type select --center-text
}
