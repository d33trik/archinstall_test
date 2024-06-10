#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

export GUM_CONFIRM_SELECTED_BACKGROUND=7
export GUM_CONFIRM_SELECTED_FOREGROUND=0
export GUM_CONFIRM_UNSELECTED_BACKGROUND=0
export GUM_CONFIRM_UNSELECTED_FOREGROUND=7

main () {
	local keymap

	show_installation_warning

	get_keyboard_layout

	setup_keyboard_layout
}

show_installation_warning() {
	local prompt=$(
		gum format \
			--type="markdown" -- \
			"$(gum style --bold --foreground="11" "Attention!")" \
			"" \
			"Welcome to my Arch Linux installation script!" \
			"" \
			"This script will guide you through an installation of Arch Linux" \
			"based on my preferred settings." \
			"" \
			"However, feel free to modify it to fit your own needs." \
			"" \
			"$(gum style --bold --foreground="9" "Important Note:") Running this script will completely erase all data" \
			"on the disk you choose for installation." \
			"" \
			"Are you ready to proceed?" |
		gum style \
			--border="normal" \
			--margin="1" \
			--padding="1 2" \
			--border-foreground="7"
	)

	gum confirm \
		--default="false" \
		"$prompt"
}

get_keyboard_layout() {
	keymap=$(
		localectl list-keymaps |
		gum filter \
			--header="Keyboard Layout" \
			--placeholder="Select your keyboard layout..."
	)
}

# TODO: Substituir nome do diretorio
setup_keyboard_layout() {
	gum spin \
		--title="Setting up the keyboard layout..." \
		-- bash archinstall_test/arch/setup_keyboard_layout.sh "$keymap"
}

main "$@"
