gitps1() {
    # shim to display git branch you are on IFF current dir has a .git directory
    export PS1='$([[ -d .git ]] && echo "($(basename $PWD).git/$(git branch|egrep "^\*"|cut "-d " -f2)) ")'"$PS1"
}
