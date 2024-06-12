username=${1:?}

sudo pacman -S --noconfirm --needed fish
chsh -s "$(which fish)" "$username"
