# launsh
Launsh all the things

## Install
```
$ git clone https://github.com/bbusse/launsh
$ cd launsh
$ sudo make install
```

## Use
### with key bindings
#### Sway
Configure key bindings via Sway config.d/
```
set $launsh_download launsh open_recent "↷" "/home/user/Downloads" 7
bindsym $mod+Shift+o exec $launsh_download
```
#### macOS
### with ALIASES
Another convenient way to launsh are ALIASES like
```
# Launsh application
alias lo="launsh application"

# Open recent Documents
alias ldc="launsh open-document Documents ~/Documents"

# Open recently downloaded files
alias ldw="launsh open-document Downloads ~/Downloads"

# Use `pass` to retrieve a password from the store: https://www.passwordstore.org/
alias lpw="launsh pass"

# Read rss feeds
alias lrss="launsh rss ${LAUNSH_DB_FILE_RSS} feeds entries"

# Open stream
alias ltv="launsh tv 📺 https://raw.githubusercontent.com/jnk22/kodinerds-iptv/master/iptv/clean/clean_tv.m3u"

# Browse images
alias li="launsh view-image "img" ~/Pictures"

# Show weather
alias lw="launsh weather --width 1400 --height 1200 --monospace"
```
## Setup
To set default applications associated with files / mimetypes,
use `xdg-utils`  
  
For example: To configure the default to zathura for pdf
```
$ xdg-mime default org.pwmt.zathura.desktop application/pdf
```

# Resources
https://www.freedesktop.org/wiki/Software/xdg-utils/  
https://github.com/bbusse/vju
