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

	echo "block_device: $block_device" >> arguments.txt
	echo "boot_mode: $boot_mode" >> arguments.txt
	echo "dotfiles: $dotfiles" >> arguments.txt
	echo "hostname: $hostname" >> arguments.txt
	echo "keymap: $keymap" >> arguments.txt
	echo "locale: $locale" >> arguments.txt
	echo "packages_to_install: $packages_to_install" >> arguments.txt
	echo "root_password: $root_password" >> arguments.txt
	echo "timezone: $timezone" >> arguments.txt
	echo "user_full_name: $user_full_name" >> arguments.txt
	echo "user_password: $user_password" >> arguments.txt
	echo "user_username: $user_username" >> arguments.txt
}

main "$@"