#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
  echo 'This script must be run as root'
  exit 1
fi

if [ ! -e /proc/sys/vm/swappiness ]; then
  echo 'This operating system is not supported'
  exit 1
fi

echo 'Tuning virtual memory'
SWAP_SYSCTL_FILE=/etc/sysctl.d/swap.conf
mkdir -p /etc/sysctl.d
cat >$SWAP_SYSCTL_FILE <<EOL
vm.swappiness=1
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
vm.dirty_background_ratio=5
EOL

echo 1 >/proc/sys/vm/swappiness
echo 50 >/proc/sys/vm/vfs_cache_pressure
echo 10 >/proc/sys/vm/dirty_ratio
echo 5 >/proc/sys/vm/dirty_background_ratio
sysctl -p $SWAP_SYSCTL_FILE

## EOF
