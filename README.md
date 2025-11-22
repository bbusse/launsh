# launsh
Launsh all the things

## Install
### Dependencies
```
$ cargo install cargo install --git https://github.com/bbusse/vju
```
### Launsh
```
$ git clone https://github.com/bbusse/launsh
$ cd launsh
$ make install
```

## Use
```
$ launsh allthethings
```
or via ALIAS
```
$ launsh install-aliases
$ lall
```
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
To enable convenient shell aliases for launsh, you must source launsh in your shell configuration file. This ensures aliases are available in your current shell session.

Add the following line to your `~/.bashrc`, `~/.zshrc`, or equivalent shell configuration file:

```sh
source launsh install-aliases
```

This will install all supported aliases for your shell session. Aliases will not persist if launsh is executed directly; it must be sourced.

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
https://mpv.io/  
https://www.passwordstore.org  
https://wttr.in/

