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
vm.swappiness = 1
vm.overcommit_memory = 1
vm.vfs_cache_pressure = 50
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
vm.panic_on_oom = 0

net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
EOL

# Apply now (no need to echo into /proc)
sysctl --system >/dev/null 2>&1 || sysctl -p $SWAP_SYSCTL_FILE

## EOF
