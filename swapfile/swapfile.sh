#!/bin/sh

trim() {
	echo "$1" | awk '{$2=$2};1'
}

parseInt() {
	echo $1 | awk '{print int($1)}'
}

rootSizeAvailable() {
	df -m / | grep '/' | awk '{print int($4/1024)}'
}

swapExists() {
	FSTAB=$(grep 'swap' /etc/fstab)
	PROC=$(grep '/' /proc/swaps)
	for swap in "/etc/fstab:$FSTAB" "/proc/swaps:$PROC"; do
		FILE=$(echo "$swap" | awk -F ':' '{print $1}')
		VALUE=$(echo "$swap" | awk -F ':' '{print $NF}')
		if [ ! -z "$VALUE" ]; then
			echo $(trim "$FILE: $VALUE")
			echo $(trim "$(cat /proc/meminfo | grep Swap)")
			return 1
		fi
	done
}

if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root"
	exit 1
fi

SWAP_EXISTS=$(swapExists)
if [ ! -z "$SWAP_EXISTS" ]; then
	echo "Swap already exists"
	echo "$SWAP_EXISTS"
	exit 0
fi

SIZE=$(parseInt ${1:-4})
if [ $SIZE -lt 1 ]; then
	echo "Usage: $0 [size]"
	echo "Example(Swap size: 4G): $0 4"
	exit 1
fi

ROOT_SIZE=$(rootSizeAvailable)
if [ $ROOT_SIZE -le $SIZE ]; then
	echo "No space left on device: /"
	echo "Swap size require: ${SIZE}G"
	echo "Root size abailable: ${ROOT_SIZE}G"
	exit 1
fi

echo "Enabling the swap file..."
echo "3" >/proc/sys/vm/drop_caches 2>/dev/null
swapoff -a
SWAP_FILE=/swapfile
rm -rf $SWAP_FILE
fallocate -l "${SIZE}G" $SWAP_FILE
chown root:root $SWAP_FILE
chmod 600 $SWAP_FILE
mkswap $SWAP_FILE
swapon $SWAP_FILE

SWAP_EXISTS=$(swapExists)
if [ ! -z "$SWAP_EXISTS" ]; then
	echo "$SWAP_EXISTS"
fi

sed -i '/swapfile/d' /etc/fstab
grep -q 'swapfile' /etc/fstab
if [ $? -ne 0 ]; then
	echo '/swapfile none swap defaults 0 0' >>/etc/fstab
fi

## EOF
