#!/usr/bin/env bash

fail() { echo "$*"; exit 1; }

progname="${1:-}"; shift || fail "Specify program binary name"
modname="${1:-}" ; shift || fail "Specify mod name/URL"

[[ "$progname" =~ ^[a-zA-Z0-9_-]+$ ]] || fail "Invalid program name '$progname"
[[ "$modname" =~ ^[a-zA-Z0-9:./_-]+$ ]] || fail "Invalid mod name/URL '$modname"

cat <<EOF >> "$progname.go"
package main

import (
    "$modname/lib"
)

func main() {
    $progname.Hello()
}
EOF

mkdir -p lib
cat <<EOF >> "lib/$progname.go"
package $progname

import (
    "fmt"
)

func Hello() {
    fmt.Printf("Hello, $progname\n")
}
EOF

cat <<EOF >> build.sh
#!/usr/bin/env bash

HERE="\$(dirname "\$0")"
cd "\$HERE"

# Create a full-static binary that should not require dependencies on libc
# https://stackoverflow.com/questions/61319677/flags-needed-to-create-static-binaries-in-golang
#CGO_ENABLED=0 go build -trimpath -o bin/$progname -a -ldflags '-extldflags -static' "$progname.go"

go build -trimpath -o "bin/$progname" "$progname.go"

EOF

chmod 755 build.sh

echo "bin/" >> .gitignore

go mod init "$modname"

