#!/bin/bash

if [[ $UID != 0 ]]; then
	echo "You must be root"
	exit 1
fi

# This is an example initial setup script for Ubuntu

apt update && apt upgrade
apt install htop zenity gksu

cat <<EOF >> $HOME/.bashrc
# ==== Automatic customization

VISUAL=/usr/bin/vim; export VISUAL
EDITOR=\$VISUAL; export EDITOR
alias crontab='crontab -i'
alias ll='ls -l'
# =====/
EOF

cat <<EOF >> $HOME/.vimrc
# ==== Automatic customization
syntax on
set autoindent
set formatoptions=tcqr
colorscheme desert
set hlsearch

# ====== /
