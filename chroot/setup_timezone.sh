timezone=${1:?}

sleep 1
ln -sf /usr/share/zoneinfo/"$timezone" /etc/localtime
timedatectl set-ntp true
hwclock --systohc
