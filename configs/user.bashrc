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

# Using `case` language construct to avoid using `[` executable file in POSIX shell
case "$BASH" in
'')
    case "$PS1" in '')
        PS1_clr=32
        PS1_sig='$'
        case "$UID" in 0)
            PS1_clr=31
            PS1_sig='#'
        ;; esac

        export PS1='\[\e['"$PS1_clr"';1m\]\u\[\e[33;1m\]@\[\e[35;1m\]\h\[\e[0m\]:\[\e[34m\]\w \[\e[36;1m\]'"$PS1_sig"'\[\e[0m\] '
    ;; esac

*) # sh does not interpret escapes etc.
    export PS1="`whoami`@`hostname` $"
    ;;
esac

export EDITOR=/usr/bin/vim
export VISUAL="$EDITOR"

export PATH="$PATH:$HOME/.local/bin"
