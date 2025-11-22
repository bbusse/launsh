# Retrieve password from the password store
# and copy password to clipboard
# Dependencies: pass - https://www.passwordstore.org/
function clip_pass() {
    local title
    title="${2}"

    cd $HOME/.password-store || exit 1

    local r
    r=$(ls -d1 */* | awk -F'.' '{print $1}' | vju --type select --title "${title} --center-text")

    r=$(pass -c "${r}")
}
