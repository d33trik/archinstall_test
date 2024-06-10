hostname=${1:?}

echo "$hostname" > /etc/hostname
pacman -S --noconfirm --needed networkmanager iptables-nft ufw gufw
# yes | pacman -S --noconfirm --needed networkmanager iptables-nft ufw gufw
systemctl enable NetworkManager.service
systemctl enable ufw.service
systemctl start ufw.service
ufw enable
