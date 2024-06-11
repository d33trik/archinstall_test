sudo pacman -S --noconfirm --needed qemu-full libvirt virt-manager iptables-nft dnsmasq dmidecode edk2-ovmf
sudo gpasswd -a $(whoami) libvirt
sudo systemctl enable libvirtd.socket
