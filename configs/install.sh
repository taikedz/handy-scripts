#!/bin/bash

cd "$(dirname "$0")"

if [[ "$UID" = 0 ]]; then
    cat root.bashrc >> /root/.bashrc
    cat vimrc >> /root/.vimrc
else
    cat user.bashrc >> "$HOME/.bashrc"
    cat vimrc >> "$HOME/.vimrc"
fi
