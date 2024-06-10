setup_keyboard_layout() {
	local keymap=${1:?}
	sleep 1
	loadkeys "$keymap"
}

setup_keyboard_layout "$@"