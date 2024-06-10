block_device=${1:?}

sleep 1
mount "${block_device}3" /mnt
swapon "${block_device}2"
[[ "$boot_mode" == 1 ]] && mkdir -p /mnt/boot && mount "${block_device}"1 /mnt/boot