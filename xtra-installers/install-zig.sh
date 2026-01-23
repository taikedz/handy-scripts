#!/usr/bin/env bash

# requires: git python3 wget xz-utils

set -euo pipefail

mkdir -p ~/.local/var/zig
cd ~/.local/var/zig

arch="$(uname -m)"
zigtag="${1:-master}"

if [[ "$zigtag" != master ]] && [[ -e "$2" ]]; then
    zigcmd="zig-${zigtag}"
else
    zigcmd="${2:-zig}"
fi

get_zig_url_py="
import json
import sys
data = json.load(sys.stdin)
print(data['$zigtag']['${arch}-linux']['tarball'])
"

# ---- Get the URL
zig_url="$(wget https://ziglang.org/download/index.json -O - -q| python3 -c "$get_zig_url_py")" || {
    echo "Failed to fetch zig @ '${zigtag}'"
    exit 1
}

tarballf="$(basename "$zig_url")"

# ---- Get the tarball
if [[ ! -e "$tarballf" ]]; then
    wget "$zig_url" -O "$tarballf"
fi

# ---- Unpack the tarball
zigdir="$(head -n1 <(tar tJf "$tarballf") )"

if [[ -e "$zigdir" ]]; then
    rm -r "$zigdir"
fi

echo "Unpacking $tarballf"
tar xJf "$tarballf" >/dev/null 2>&1

# ---- Symlink the zig binary
if [[ -L ~/.local/bin/$zigcmd ]]; then
    unlink ~/.local/bin/$zigcmd
fi

zigpath="$(readlink -f $zigdir)/zig"
BINDIR="$HOME/.local/bin"
mkdir -p "$BINDIR"
ln -s "$zigpath" "$BINDIR/$zigcmd"

# ---- Add zig plugin for vim
# vim plugins dir
VPDIR="$HOME/.vim/pack/plugins/start"
if [[ ! -d "$VPDIR/zig.vim" ]]; then
    (
    mkdir -p "$VPDIR"
    cd "$VPDIR"
    git clone "https://github.com/ziglang/zig.vim"
    )
fi

# ---- Validate install

if ! which $zigcmd; then
    echo "You need to add ~/.local/bin to your \$PATH"
fi

echo Done.

