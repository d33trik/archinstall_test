mirrorlist_region=${1:?}
country_code=$(echo "$mirrorlist_region" | awk -F'[()]' '{print $2}')
mirrorlist_url="https://archlinux.org/mirrorlist/?country=$country_code&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

pacman -S ----noconfirm --needed pacman-contrib &&
curl -s "$mirrorlist_url" > /etc/pacman.d/mirrorlist.unranked &&
sed '/^##/d; /^[[:space:]]*$/d; s/^#Server/Server/' /etc/pacman.d/mirrorlist.unranked > /etc/pacman.d/mirrorlist.tmp &&
mv /etc/pacman.d/mirrorlist.tmp /etc/pacman.d/mirrorlist.unranked &&
rankmirrors -n 5 /etc/pacman.d/mirrorlist.unranked > /etc/pacman.d/mirrorlist &&
rm /etc/pacman.d/mirrorlist.unranked
