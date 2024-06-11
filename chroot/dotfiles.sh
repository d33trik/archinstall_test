sudo pacman -S --noconfirm --needed git
git clone https://github.com/d33trik/dotfiles.git "$HOME"/dotfiles
cd "$HOME"/dotfiles
chmod u+x install.sh
bash install.sh
