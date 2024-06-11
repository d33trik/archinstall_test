#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

export GUM_SPIN_SHOW_ERROR=true
export GUM_SPIN_SPINNER=line
export GUM_SPIN_SPINNER_FOREGROUND=10
export GUM_SPIN_TITLE_FOREGROUND=15

main() {
	local block_device=${1:?}
	local boot_mode=${2:?}
	local hostname=${3:?}
	local keymap=${4:?}
	local locale=${5:?}
	local root_password=${6:?}
	local timezone=${7:?}
	local user_full_name=${8:?}
	local user_password=${9:?}
	local user_username=${10:?}

	install_gum
	setup_root_password
	setup_user_account
	setup_timezone
	setup_localization
	setup_graphical_interface
	setup_audio_interface
	setup_network_interface
	setup_bootloader
	enable_sudo_execution_without_password
	install_yay
	install_packages
	install_dotfiles
	disable_sudo_execution_without_password
}

install_gum() {
	clear
	echo "Installing gum..."
	pacman -Sy --noconfirm --needed gum &> /dev/null
	clear
}

setup_root_password() {
	gum spin \
		--title="Setting up the root password..." \
		-- bash archinstall_test/chroot/setup_root_password.sh "$root_password"
}

setup_user_account() {
	gum spin \
		--title="Setting up the user account..." \
		-- bash archinstall_test/chroot/setup_user_account.sh "$user_full_name" "$user_username" "$user_password"
}

setup_timezone() {
	gum spin \
		--title="Setting up the timezone..." \
		-- bash archinstall_test/chroot/setup_timezone.sh "$timezone"
}

setup_localization() {
	gum spin \
		--title="Setting up the localization..." \
		-- bash archinstall_test/chroot/setup_localization.sh "$locale" "$keymap"
}

setup_graphical_interface() {
	gum spin \
		--title="Setting up the graphical interface..." \
		-- bash archinstall_test/chroot/setup_graphical_interface.sh "$keymap"
}

setup_audio_interface() {
	gum spin \
		--title="Setting up the audio interface..." \
		-- bash archinstall_test/chroot/setup_audio_interface.sh
}

setup_network_interface() {
	gum spin \
		--title="Setting up the network interface..." \
		-- bash archinstall_test/chroot/setup_network_interface.sh "$hostname"
}

setup_bootloader() {
	gum spin \
		--title="Setting up the bootloader..." \
		-- bash archinstall_test/chroot/setup_bootloader.sh "$boot_mode" "$block_device"
}

enable_sudo_execution_without_password() {
	gum spin \
		--title="Enabling sudo execution without a password..." \
		-- bash archinstall_test/chroot/enable_sudo_execution_without_password.sh
}

install_yay() {
	gum spin \
		--title="Installing yay..." \
		-- sudo -u "$user_username" bash archinstall_test/chroot/yay.sh
}

install_packages() {
	sudo -u "$user_username" bash archinstall_test/install_packages.sh
}

install_dotfiles() {
	gum spin \
		--title="Installing dotfiles..." \
		-- sudo -u "$user_username" bash archinstall_test/chroot/dotfiles.sh
}

disable_sudo_execution_without_password() {
	gum spin \
		--title="Disabling sudo execution without a password..." \
		-- bash archinstall_test/chroot/disable_sudo_execution_without_password.sh
}

main "$@"
