block_device=${1:?}
boot_partition_type=${2:?}
swap_size=${3:?}

sleep 1
partprobe "$block_device"
fdisk "$block_device" << EOF
g
n


+512M
t
$boot_partition_type
n


+${swap_size}G
n



w
EOF
partprobe "$block_device"
