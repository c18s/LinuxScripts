#!/bin/sh

getPlatform() {
  OS_RELEASE_FILE=/etc/os-release
  sed -n 's#^ID=\(.*\)#\1#p' "$OS_RELEASE_FILE" 2>/dev/null || echo unknown
}

if [ "$(id -u)" -ne 0 ]; then
  echo 'This script must be run as root'
  exit 1
fi

if ! type sudo >/dev/null 2>&1; then
  echo 'sudo: command not found'
  exit 1
fi

if ! type adduser >/dev/null 2>&1; then
  echo 'adduser: command not found'
  exit 1
fi

if [ -z "$USER" ]; then
  echo 'USER environment is required'
  exit 1
fi

if ! id -u "$USER" >/dev/null 2>&1; then
  echo "Creating a user account: $USER"
  PLATFORM="$(getPlatform)"
  case $PLATFORM in
  alpine)
    adduser -D -g '' -s /bin/ash "$USER"
    ;;
  debian* | ubuntu | raspbian*)
    adduser --disabled-password --gecos '' "$USER"
    ;;
  *)
    useradd -m -s /bin/bash "$USER"
    ;;
  esac
  if [ ! -z "$PASSWORD" ]; then
    echo "${USER}:${PASSWORD}" | chpasswd
  fi
  if ! id -u "$USER" >/dev/null 2>&1; then
    echo "Cannot create user account: $USER"
    exit 1
  fi
fi

# sudoers directory
SUDOERS_DIR=/etc/sudoers.d
SUDOERS_FILE=/etc/sudoers
SUDOERS_USER_FILE="${SUDOERS_DIR}/${USER}"
mkdir -p $SUDOERS_DIR

# sudoers user file
SUDOERS_TEXT="${USER} ALL=(ALL:ALL) NOPASSWD:ALL"
if [ "$SUDO_NOPASS" = 'no' ]; then
  SUDOERS_TEXT="${USER} ALL=(ALL:ALL) ALL"
fi
echo "$SUDOERS_TEXT" >$SUDOERS_USER_FILE
chmod 644 $SUDOERS_USER_FILE

# update sudoers config
echo "#includedir /etc/sudoers.d" >>$SUDOERS_FILE
SUDOERS_CONFIG="$(cat $SUDOERS_FILE)"
echo "$SUDOERS_CONFIG" | awk '!NF || !x[$0]++' | sed '/./,/^$/!d' >$SUDOERS_FILE
grep "includedir" $SUDOERS_FILE
cat $SUDOERS_USER_FILE

## EOF
