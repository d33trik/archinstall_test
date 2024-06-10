#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

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

# TODO: Subistituir url do repositorio
clone_archinstall_repository() {
	gum spin \
		--title="Cloning archinstall repository..." \
		-- bash -c "
			git clone https://github.com/d33trik/archinstall_test.git
		"
}

# TODO: Substituir nome do diretorio
install_arch() {
	bash archinstall_teste/install_arch.sh
}

main "$@"