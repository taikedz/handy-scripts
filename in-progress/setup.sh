#!/bin/bash

# This is an example initial setup script for Ubuntu

cat <<EOF >> $HOME/.bashrc
# ==== Automatic customization

VISUAL=/usr/bin/vim; export VISUAL
EDITOR=\$VISUAL; export EDITOR
alias crontab='crontab -i'
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
