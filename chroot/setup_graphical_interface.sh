keymap=${1:?}

pacman -S --noconfirm --needed xorg xorg-xinit i3-wm i3status i3lock arandr dmenu feh arc-gtk-theme arc-icon-theme breeze
mkdir -p /etc/X11/xorg.conf.d
cat <<EOF > /etc/X11/xorg.conf.d/00-keyboard.conf
Section "InputClass"
	Identifier "system-keyboard"
	MatchIsKeyboard "on"
	Option "XkbLayout" ""$keymap""
EndSection
EOF
