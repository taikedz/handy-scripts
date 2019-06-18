# // HANDYCONFIG
# ^--- do not delete

# PS1 override
#
# Write the desired pattern, eg
#
#   export PS1='\e[32;1m\u\e[33;1m@\e[35;1m\h\e[0m:\e[34m\w \e[36;1m\$\e[0m '
#
# Then apply this in vim to ensure the line breaks don't go wonky
#
#   s/\(\\e\[[^m]\+m\)/\\[\1\\]/g

export PS1='\[\e[32;1m\]\u\[\e[33;1m\]@\[\e[35;1m\]\h\[\e[0m\]:\[\e[34m\]\w \[\e[36;1m\]\$\[\e[0m\] '

export EDITOR=/usr/bin/vim
export VISUAL="$EDITOR"

export PATH="$PATH:$HOME:/.local/bin"
