root_password=${1:?}

sleep 1
echo "root:$root_password" | chpasswd
