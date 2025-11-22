.PHONY: install

install:

# Create directories
	install -d ${HOME}/.local/bin/
	install -d ${HOME}/.local/share/launsh/modules/
	install -d ${HOME}/.config/sway/config.d/

# Copy script and modules
	install -m 0644 modules/* ${HOME}/.local/share/launsh/modules/
	install -m 0644 launsh-keybindings-sway ${HOME}/.config/sway/config.d/
