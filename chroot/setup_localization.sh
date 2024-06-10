locale=${1:?}
keymap=${2:?}
locale_prefix=$(echo $locale | awk '{print $1}')

sleep 1
echo "$locale" >> /etc/locale.gen
locale-gen
echo "LANG=$locale_prefix" > /etc/locale.conf
echo "KEYMAP=$keymap" >> /etc/vconsole.conf
