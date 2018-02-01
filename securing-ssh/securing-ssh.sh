#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
  echo 'This script must be run as root'
  exit 1
fi

SSHD_CONFIG_FILE=/etc/ssh/sshd_config
SSHD_CONFIG_BACKUP_FILE=/etc/ssh/sshd_config.backup
AUTHORIZED_KEYS_FILE=/etc/ssh/authorized_keys

if [ ! -e $SSHD_CONFIG_FILE ]; then
  echo 'This operating system is not supported'
  exit 1
fi

if [ ! -e $AUTHORIZED_KEYS_FILE ]; then
  touch $AUTHORIZED_KEYS_FILE
  chmod 644 $AUTHORIZED_KEYS_FILE
fi

if [ ! -e $SSHD_CONFIG_BACKUP_FILE ]; then
  cp $SSHD_CONFIG_FILE $SSHD_CONFIG_BACKUP_FILE
fi

updateConfig() {
  SSHD_CONFIG=$(sed "$2" $SSHD_CONFIG_FILE)
  [ $? -ne 0 ] && return
  echo "$SSHD_CONFIG" | awk '!a[$0]++' >$SSHD_CONFIG_FILE
  grep "$1" $SSHD_CONFIG_FILE
}

echo 'Secure the SSH server'

# default
updateConfig 'PermitEmptyPasswords' 's/^.*PermitEmptyPasswords.*$/PermitEmptyPasswords no/'
updateConfig 'TCPKeepAlive' 's/^.*TCPKeepAlive.*$/TCPKeepAlive yes/'
updateConfig 'ClientAliveInterval' 's/^.*ClientAliveInterval.*$/ClientAliveInterval 300/'
updateConfig 'ClientAliveCountMax' 's/^.*ClientAliveCountMax.*$/ClientAliveCountMax 0/'
updateConfig 'AuthorizedKeysFile' 's@^.*AuthorizedKeysFile.*$@AuthorizedKeysFile .ssh/authorized_keys /etc/ssh/authorized_keys@'

isYesOrNo() {
  echo "$1" | grep -q -E '^(yes|no)$' 2>/dev/null
  return $?
}

if isYesOrNo "$ROOT_LOGIN"; then
  updateConfig 'PermitRootLogin' "s/^.*PermitRootLogin.*$/PermitRootLogin $ROOT_LOGIN/"
fi

if isYesOrNo "$PASSWORD_LOGIN"; then
  updateConfig 'PasswordAuthentication' "s/^.*PasswordAuthentication.*$/PasswordAuthentication $PASSWORD_LOGIN/"
  updateConfig 'UsePAM' "s/^.*UsePAM.*$/UsePAM $PASSWORD_LOGIN/"
fi

if isYesOrNo "$X11_FORWARDING"; then
  updateConfig 'X11Forwarding' "s/^.*X11Forwarding.*$/X11Forwarding $X11_FORWARDING/"
fi

## EOF
