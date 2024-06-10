boot_mode=${1:?}
block_device=${2:?}

sleep 1
[[ "$boot_mode" == 1 ]] && mkfs.fat -F32 "${block_device}1"
mkswap "${block_device}2"
mkfs.ext4 "${block_device}3"