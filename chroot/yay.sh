sudo pacman -S --noconfirm --needed git base-devel
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg --noconfirm -si
sudo pacman -Rs --noconfirm go
