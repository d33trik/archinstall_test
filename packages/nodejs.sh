if [ ! -e "$HOME/.asdf/asdf.sh" ]; then
	bash archinstall_test/packages/asdf.sh
fi

source "$HOME"/.asdf/asdf.sh
asdf plugin add nodejs
asdf nodejs update-nodebuild
asdf install nodejs $(asdf nodejs resolve lts --latest-available)
asdf global nodejs $(asdf nodejs resolve lts --latest-available)
