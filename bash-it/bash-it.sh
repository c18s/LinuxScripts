#!/bin/sh

if ! type git >/dev/null 2>&1; then
  echo 'git: command not found'
  exit 1
fi

cd ~/
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --silent

if [ "$(id -u)" -ne 0 ]; then
  sed -i "s/^.*export BASH_IT_THEME=.*$/export BASH_IT_THEME='axin'/" ~/.bash_profile >/dev/null 2>&1
  sed -i "s/^.*export BASH_IT_THEME=.*$/export BASH_IT_THEME='axin'/" ~/.bashrc >/dev/null 2>&1
else
  sed -i "s/^.*export BASH_IT_THEME=.*$/export BASH_IT_THEME='binaryanomaly'/" ~/.bash_profile >/dev/null 2>&1
  sed -i "s/^.*export BASH_IT_THEME=.*$/export BASH_IT_THEME='binaryanomaly'/" ~/.bashrc >/dev/null 2>&1
fi

## EOF
