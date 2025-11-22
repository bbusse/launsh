# Uses https://wttr.in for weather data
# Dependencies: curl, https://github.com/bbusse/whereintheworldis
# TODO: Use coordinates
function weather() {
    local location
    location=$(witwi --output city)

    curl -sS wttr.in/${location}?T\&?format="%t+(%f)+%c+%C+%P+%h" | vju --width 1300 --height 800 --font-size 16 --monospace
}
