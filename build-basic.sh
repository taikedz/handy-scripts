cd "$(dirname "$0")"

bbuild src/install.sh ./install.sh

bbuild --out=bin src/portblock
bbuild --out=bin src/sendme
bbuild --out=bin src/datereset
bbuild --out=bin src/brightness
bbuild --out=bin src/mdpreview
bbuild --out=bin src/mvaudio
bbuild --out=bin src/pow
bbuild --out=bin src/saytimer
bbuild --out=bin src/sendme
bbuild --out=bin src/wifi
bbuild --out=bin src/z64
bbuild src/vpn.sh bin/vpn
