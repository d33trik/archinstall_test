#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

export GUM_SPIN_SPINNER=line
export GUM_SPIN_SPINNER_FOREGROUND=10
export GUM_SPIN_TITLE_FOREGROUND=15

main() {
	install_gum

	install_git

	clone_archinstall_repository

	install_arch
}

install_gum() {
	clear
	echo "Installing gum..."
	pacman -Sy --noconfirm --needed gum &> /dev/null
	clear
}

install_git() {
	gum spin \
		--title="Installing git..." \
		-- bash -c "
			pacman -S --noconfirm --needed git
		"
}

clone_archinstall_repository() {
	gum spin \
		--title="Cloning archinstall repository..." \
		-- bash -c "
			rm -rf archinstall_test
			git clone https://github.com/d33trik/archinstall_test.git
		"
}

install_arch() {
	bash archinstall_test/install_arch.sh
}

main "$@"
