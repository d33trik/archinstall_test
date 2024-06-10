#!/bin/bash

# e - script stops on error
# u - error if undefined variable
# o pipefail - script fails if command piped fails
set -euo pipefail

export GUM_CHOOSE_CURSOR_PREFIX="[ ] "
export GUM_CHOOSE_CURSOR_FOREGROUND=10
export GUM_CHOOSE_HEADER_FOREGROUND=15
export GUM_CHOOSE_HEIGHT=50
export GUM_CHOOSE_ITEM_FOREGROUND=9
export GUM_CHOOSE_SELECTED_PREFIX="[X] "
export GUM_CHOOSE_SELECTED_FOREGROUND=10
export GUM_CHOOSE_UNSELECTED_PREFIX="[ ] "

export GUM_CONFIRM_SELECTED_BACKGROUND=7
export GUM_CONFIRM_SELECTED_FOREGROUND=0
export GUM_CONFIRM_UNSELECTED_BACKGROUND=0
export GUM_CONFIRM_UNSELECTED_FOREGROUND=7

export GUM_FILTER_CURSOR_TEXT_FOREGROUND=10
export GUM_FILTER_HEADER_FOREGROUND=15
export GUM_FILTER_INDICATOR_FOREGROUND=10
export GUM_FILTER_MATCH_FOREGROUND=10
export GUM_FILTER_PROMPT_FOREGROUND=10
export GUM_FILTER_SELECTED_PREFIX=" [X] "
export GUM_FILTER_SELECTED_PREFIX_FOREGROUND=10
export GUM_FILTER_UNSELECTED_PREFIX=" [ ] "
export GUM_FILTER_UNSELECTED_PREFIX_FOREGROUND=9
export GUM_FILTER_WIDTH=0

export GUM_INPUT_CURSOR_FOREGROUND=7
export GUM_INPUT_CURSOR_MODE=static
export GUM_INPUT_PROMPT_FOREGROUND=10
export GUM_INPUT_WIDTH=0
export GUM_INPUT_HEADER_FOREGROUND=15

export GUM_SPIN_SHOW_ERROR=true
export GUM_SPIN_SPINNER=line
export GUM_SPIN_SPINNER_FOREGROUND=10
export GUM_SPIN_TITLE_FOREGROUND=15

main () {
	local keymap
	local locale
	local timezone
	local root_password
	local root_password_confirmation
	local user_full_name
	local user_username
	local user_password
	local user_password_confirmation
	local hostname
	local block_device
	local swap_size
	local wipe_method
	local mirrorlist_region
	local boot_mode
	local boot_partition_type

	show_installation_warning
	get_keyboard_layout
	setup_keyboard_layout
	get_locale
	get_timezone
	get_root_password
	get_root_password_confirmation
	validate_root_password
	get_user_full_name
	get_user_username
	get_user_password
	get_user_password_confirmation
	validate_user_password
	get_hostname
	get_block_device
	get_swap_size
	get_wipe_method
	get_mirrorlist_region
	show_isntallation_summary
	verify_boot_mode
	update_system_clock
	wipe_block_device
	partition_block_device
	format_partitions
	mount_filesystems
	uptate_pacman_mirrorlist
	install_essential_packages
	generate_fstab
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

setup_keyboard_layout() {
	gum spin \
		--title="Setting up the keyboard layout..." \
		-- bash archinstall_test/arch/setup_keyboard_layout.sh "$keymap"
}

get_locale() {
	locale=$(
		cat /usr/share/i18n/SUPPORTED |
		gum filter \
			--header="Locale" \
			--placeholder="Select your preferred locale..."
	)
}

get_timezone() {
	timezone=$(
		timedatectl list-timezones |
		gum filter \
			--header="Timezone" \
			--placeholder="Select your time zone..."
	)
}

get_root_password() {
	root_password=$(
		gum input \
			--password="true" \
			--header="Root Password" \
			--placeholder="Set a secure root password..."
	)
}

get_root_password_confirmation() {
	root_password_confirmation=$(
		gum input \
			--password="true" \
			--header="Root Password Confirmation" \
			--placeholder="Confirm your root password..."
	)
}

validate_root_password() {
	if [[ $root_password != $root_password_confirmation ]]; then
		echo -e "$(gum style --bold --foreground="9" "ERROR:") Passwords do not match. Please try again."; sleep 2; clear
		get_root_password
		get_root_password_confirmation
		validate_root_password
	fi
}

get_user_full_name() {
	user_full_name=$(
		gum input \
			--header="User Full Name" \
			--placeholder="Please enter your first and last name..."
	)
}

get_user_username() {
	user_username=$(
		gum input \
			--header="User Username" \
			--placeholder="Create a username for your account...."
	)
}

get_user_password() {
	user_password=$(
		gum input \
			--password="true" \
			--header="User Password" \
			--placeholder="Set a secure password..."
	)
}

get_user_password_confirmation() {
	user_password_confirmation=$(
		gum input \
			--password="true" \
			--header="User Password Confirmation" \
			--placeholder="Confirm your password..."
	)
}

validate_user_password() {
    if [[ $user_password != $user_password_confirmation ]]; then
        echo -e "$(gum style --bold --foreground="9" "ERROR:") Passwords do not match. Please try again."; sleep 2; clear
        get_user_password
        get_user_password_confirmation
        validate_user_password
    fi
}

get_hostname() {
    hostname=$(
        gum input \
            --header="Hostname" \
            --placeholder="Enter a hostname for your system...."
    )
}

get_block_device() {
    block_device=$(
        lsblk \
            --noheadings \
            --nodeps \
            --paths \
            --output NAME,SIZE |
        gum filter \
            --header="Block Device" \
            --placeholder="Select the block device where you want to install the system..."
    )

     block_device=$(
        echo $block_device |
        awk '{print $1}'
    )
}

get_swap_size() {
	local default_swap_size=8

	swap_size=$(
		gum input \
			--header="SWAP Size" \
			--placeholder="Enter a value for the swap size, leave blank to default (8GB)..."
	)

	[[ $swap_size =~ ^[0-9]+$ ]] || swap_size=$default_swap_size
}

get_wipe_method() {
	local wipe_methods=(
		"1 DD /dev/zero (Faster & Prevent Easy Recovery)"
		"2 DD /dev/random (Slower & Prevent Hard Recovery)"
		"3 No Need (The Device is Empty)"
	)

	wipe_method=$(
		printf "%s\n" "${wipe_methods[@]}" |
		gum filter \
			--header="Wipe Method" \
			--placeholder="Select your preferred wipe method..."
	)
}

get_mirrorlist_region() {
	local regions=$(cat "archinstall_test/resources/mirrorlist_regions.txt")

	mirrorlist_region=$(
		echo "$regions" |
		gum filter \
			--header="Pacman Mirrorlist" \
			--placeholder="Select the region closest to your location..."
	)
}

show_isntallation_summary() {
	local prompt=$(
		gum format \
			--type="markdown" -- \
			"$(gum style --bold --foreground="10" "Ready to Install?")" \
			"" \
			"Here's a quick overview of your Arch Linux setup:" \
			"" \
			"$(gum style --bold --foreground="10" "[User]")" \
			"Name:                 $user_full_name" \
			"Username:             $user_username" \
			"" \
			"$(gum style --bold --foreground="10" "[System]")" \
			"Locale:               $locale" \
			"Timezone:             $timezone" \
			"Keyboard Layout:      $keymap" \
			"Hostname:             $hostname" \
			"Mirrorlist Region:    $mirrorlist_region" \
			"" \
			"$(gum style --bold --foreground="10" "[Instalation]")" \
			"Block Device:         $block_device" \
			"SWAP Size:            $swap_size GB" \
			"Whipe Method:         $wipe_method" |
		gum style \
			--border="normal" \
			--margin="1" \
			--padding="1 2" \
			--border-foreground="7"
	)

	gum confirm \
		--default="false" \
		--affirmative="Yes, Install" \
		--negative="No, Edit" \
		"$prompt"
}

verify_boot_mode() {
	gum spin \
		--title="Verifying boot mode..." \
		-- sleep 1

	if cat /sys/firmware/efi/fw_platform_size &> /dev/null; then
		boot_mode=1
		boot_partition_type=1
	else
		boot_mode=0
		boot_partition_type=4
	fi
}

update_system_clock() {
	gum spin \
		--title="Updating system clock..." \
		-- bash archinstall_test/arch/update_system_clock.sh
}

wipe_block_device() {
	bash archinstall_test/arch/wipe_block_device.sh "$block_device" "$wipe_method"
}

partition_block_device() {
	gum spin \
		--title="Partitioning block device $block_device..." \
		-- bash archinstall_test/arch/partition_block_device.sh "$block_device" "$boot_partition_type" "$swap_size"
}

format_partitions() {
	echo "$block_device" | grep -E 'nvme' &>/dev/null && block_device="${block_device}p"

	gum spin \
		--title="Formatting partitions..." \
		-- bash archinstall_test/arch/format_partitions.sh "$boot_mode" "$block_device"
}

mount_filesystems() {
	gum spin \
		--title="Mounting filesystems..." \
		-- bash archinstall_test/arch/mount_filesystems.sh "$block_device" "$boot_mode"
}

uptate_pacman_mirrorlist() {
	gum spin \
		--title="Updating pacman mirrorlist..." \
		-- bash archinstall_test/arch/uptate_pacman_mirrorlist.sh "$mirrorlist_region"
}

install_essential_packages() {
	bash archinstall_test/arch/install_essential_packages.sh
}

generate_fstab() {
	gum spin \
		--title="Generating fstab..." \
		-- bash archinstall_test/arch/generate_fstab.sh
}


main "$@"
