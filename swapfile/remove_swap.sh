#!/bin/sh

trim() {
  echo "$1" | awk '{$2=$2};1'
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
  echo 'This script must be run as root'
  exit 1
fi

if [ ! -e /proc/meminfo ]; then
  echo 'This operating system is not supported'
  exit 1
fi

echo 'Removing the swap file...'
echo '3' >/proc/sys/vm/drop_caches 2>/dev/null
swapoff -a
SWAP_FILE=${SWAP_FILE:-/swapfile}
rm -rf $SWAP_FILE

SWAP_EXISTS=$(swapExists)
if [ ! -z "$SWAP_EXISTS" ]; then
  echo "$SWAP_EXISTS"
fi

sed -i "\|$SWAP_FILE|d" /etc/fstab

## EOF
