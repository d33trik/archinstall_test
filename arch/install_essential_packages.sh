echo "$(gum style --foreground="15" "Instaling essential packages...")"
sleep 1
pacstrap -K /mnt base base-devel linux linux-firmware
sleep 1
clear
