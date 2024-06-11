sudo pacman -S --noconfirm --needed curl git
git clone https://github.com/asdf-vm/asdf.git "$HOME"/.asdf --branch v0.14.0
echo '. $HOME/.asdf/asdf.sh' >> "$HOME"/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> "$HOME"/.bashrc
