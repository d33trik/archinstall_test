sudo pacman -S --noconfirm --needed fuse2
curl -sLo obsidian.AppImage $(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep browser_download_url.*AppImage | grep -v "arm64" | cut -d\" -f4)
sudo mkdir /opt/obsidian
sudo mv obsidian.AppImage /opt/obsidian
sudo chmod +x /opt/obsidian/obsidian.AppImage
sudo ln -s /opt/obsidian/obsidian.AppImage /usr/bin/obsidian
