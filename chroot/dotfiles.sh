export XDG_CONFIG_HOME="$HOME/.config"
export DOTFILES="$HOME/dotfiles"

sudo pacman -S --noconfirm --needed git
git clone https://github.com/d33trik/dotfiles.git "$HOME"/dotfiles
cd "$HOME"/dotfiles
chmod u+x install.sh
mkdir -p "$HOME/.config"
bash install.sh
