user_full_name=${1:?}
user_username=${2:?}
user_password=${3:?}

sleep 1
useradd -m -g wheel -s /bin/bash -c "$user_full_name" "$user_username"
echo "$user_username:$user_password" | chpasswd
sed -i '/^# %wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers
