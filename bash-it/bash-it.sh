#!/bin/sh

if ! type git >/dev/null 2>&1; then
  echo 'git: command not found'
  exit 1
fi

INSTALL_PATH=/root
THEME=binaryanomaly

if [ "$(id -u)" -eq 0 ]; then
  echo 'Bash-it: Rus script as root'
  if [ ! -z "$USER" ] && [ -d "/home/$USER" ]; then
    INSTALL_PATH=/home/$USER
    THEME=dulcie
    su -c "cd $INSTALL_PATH && git clone --depth=1 https://github.com/Bash-it/bash-it.git $INSTALL_PATH/.bash_it" $USER
    su -c "HOME=$INSTALL_PATH $INSTALL_PATH/.bash_it/install.sh --silent" $USER
  else
    cd $INSTALL_PATH && git clone --depth=1 https://github.com/Bash-it/bash-it.git $INSTALL_PATH/.bash_it
    HOME=$INSTALL_PATH $INSTALL_PATH/.bash_it/install.sh --silent
  fi
else
  INSTALL_PATH=~
  THEME=dulcie
  cd $INSTALL_PATH && git clone --depth=1 https://github.com/Bash-it/bash-it.git $INSTALL_PATH/.bash_it
  HOME=$INSTALL_PATH $INSTALL_PATH/.bash_it/install.sh --silent
fi

sed -i "s/^.*export BASH_IT_THEME=.*$/export BASH_IT_THEME='$THEME'/" $INSTALL_PATH/.bash_profile >/dev/null 2>&1
sed -i "s/^.*export BASH_IT_THEME=.*$/export BASH_IT_THEME='$THEME'/" $INSTALL_PATH/.bashrc >/dev/null 2>&1

## EOF
