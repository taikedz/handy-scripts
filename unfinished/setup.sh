#!/bin/bash

if [[ $UID = 0 ]]; then
	if [[ $(uname -a | grep -i ubuntu -c) -gt 0 ]]; then
		apt-get update && apt-get upgrade
		apt-get install htop tmux
	fi
fi

cat <<EOF >> $HOME/.bashrc
# ==== Automatic customization
export VISUAL=/usr/bin/vim
export EDITOR=\$VISUAL
alias crontab='crontab -i'
alias ll='ls -l'
export PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "
# =====/
EOF

cat <<EOF >> $HOME/.vimrc
" ==== Automatic customization
syntax on
set autoindent
set formatoptions=tcqr
colorscheme desert
set hlsearch
" ====== /
EOF
