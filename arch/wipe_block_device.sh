block_device=${1:?}
wipe_method=${2:?}
block_device_size=$(sudo blockdev --getsize64 $block_device)
wipe_method_code=$( echo $wipe_method | awk '{print $1}')

set +e
case $wipe_method_code in
1)
	echo "$(gum style --foreground="15" "Wiping block device $block_device...")"
	dd if=/dev/zero | pv --progress --timer --eta --size $block_device_size | dd of=$block_device &>/dev/null
	;;
2)
	echo "$(gum style --foreground="15" "Wiping block device $block_device...")"
	dd if=/dev/random | pv --progress --timer --eta --size $block_device_size | dd of=$block_device &>/dev/null
	;;
3)
	;;
esac
set -e

sleep 1
clear