# Launsh application
function lopen() {
    local commands alias_names function_names

    # Get all unique executable names in PATH
    commands=$(IFS=:; for dir in ${PATH}; do
        [ -d "${dir}" ] && find "${dir}" -maxdepth 1 -type f -perm -111 2>/dev/null
    done | awk -F/ '{print $NF}' | sort -u)

    # Get all macOS .app bundles in /Applications, /Applications/Utilities, and ~/Applications
    macos_apps=$(find /Applications /Applications/Utilities "$HOME/Applications" -maxdepth 2 -type d -name '*.app' 2>/dev/null | awk -F/ '{print $NF}' | sed 's/\.app$//')


    # Get all user-defined function names (excluding _* and zsh internals)
    function_names=$(zsh -i -c 'functions' | grep -E '^[a-zA-Z0-9_]+[[:space:]]*\(\)' | sed 's/().*//;s/ *$//' | grep -v '^_')

    alias_names=$(zsh -i -c 'alias' | awk -F'=' '{print $1}')

    r=$({ printf "%s\n" $commands; printf "%s\n" $macos_apps; printf "%s\n" $alias_names; printf "%s\n" $function_names; } | sort -u | vju --type select --width 500 --center-text --show-search --title "Open Application")

    if [ -n "${r}" ]; then
        if [ "${r}" = "vju-exit" ]; then
            return 0
        fi

        # Check for .app anywhere in /Applications*, /Applications/Utilities*, or ~/Applications*
        app_path=$(find /Applications /Applications/Utilities "${HOME}/Applications" -maxdepth 2 -type d -name "${r}.app" 2>/dev/null | head -n 1)
        if [ -n "${app_path}" ]; then
            /usr/bin/open "${app_path}"
            return 0
        fi

        # Check if alias exists in an interactive zsh shell
        if zsh -i -c "whence -w ${r}" | grep -Eq 'alias|function'; then
            zsh -i -c "${r}"
            zsh -i -c "${r}"
        fi

        zsh -c "${r}" &
        return 0
    fi
}
