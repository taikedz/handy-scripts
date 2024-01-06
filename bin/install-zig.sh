#!/usr/bin/env bash

mkdir -p ~/.local/var/zig
cd ~/.local/var/zig

arch="$(uname -m)"
zigtag="${1:-master}"

if [[ "$zigtag" != master ]]; then
    zigcmd="zig-${zigtag}"
else
    zigcmd=zig
fi

get_zig_url_py="
import json
import sys
data = json.load(sys.stdin)
print(data['$zigtag']['${arch}-linux']['tarball'])
"

# ---- Get the URL
zig_url="$(wget https://ziglang.org/download/index.json -O - -q| python3 -c "$get_zig_url_py")" || {
    echo "Failed to fetch zig version '${zigtag}'"
    exit 1
}

tarballf="$(basename "$zig_url")"

# ---- Get the tarball
if [[ ! -e "$tarballf" ]]; then
    wget "$zig_url" -O "$tarballf"
fi

# ---- Unpack the tarball
zigdir="$(tar tJf "$tarballf"|head -n1)"

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
ln -s "$zigpath" ~/.local/bin/$zigcmd

# ---- Validate install

if ! which $zigcmd; then
    echo "You need to add ~/.local/bin to your \$PATH"
fi

echo Done.

