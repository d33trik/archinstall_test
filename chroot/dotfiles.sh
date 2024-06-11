sudo pacman -S --noconfirm --needed git
git clone $dotfiles_url "$HOME"/dotfiles
cd "$HOME"/dotfiles
chmod u+x install.sh
bash install.sh
