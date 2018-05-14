#!/bin/sh

if ! type git >/dev/null 2>&1; then
  echo 'git: command not found'
  exit 1
fi

## --- check user ---
INSTALL_PATH=/root
THEME=binaryanomaly
if [ "$(id -u)" -ne 0 ]; then
  INSTALL_PATH=~
  THEME=dulcie
fi

cd $INSTALL_PATH
git clone --depth=1 https://github.com/Bash-it/bash-it.git $INSTALL_PATH/.bash_it
$INSTALL_PATH/.bash_it/install.sh --silent

sed -i "s/^.*export BASH_IT_THEME=.*$/export BASH_IT_THEME='$THEME'/" $INSTALL_PATH/.bash_profile >/dev/null 2>&1
sed -i "s/^.*export BASH_IT_THEME=.*$/export BASH_IT_THEME='$THEME'/" $INSTALL_PATH/.bashrc >/dev/null 2>&1

## EOF
