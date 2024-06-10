boot_mode=${1:?}
block_device=${2:?}

if [ "$boot_mode" = 1 ]; then
	pacman -S --noconfirm --needed grub efibootmgr
	grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot
else
	pacman -S --noconfirm --needed grub
	grub-install "$block_device"
fi

grub-mkconfig -o /boot/grub/grub.cfg
