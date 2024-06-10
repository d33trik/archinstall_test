hostname=${1:?}

echo "$hostname" > /etc/hostname
yes | pacman -S --needed networkmanager iptables-nft ufw gufw
systemctl enable NetworkManager.service
systemctl enable ufw.service
systemctl start ufw.service
ufw enable
