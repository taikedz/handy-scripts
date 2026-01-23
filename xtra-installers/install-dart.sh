set -euo pipefail

if [[ "$UID" != 0 ]]; then
    echo "Need to run as root"
    exit 1
fi

apt-get update && apt-get install apt-transport-https wget gpg -y

wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg  --dearmor -o /usr/share/keyrings/dart.gpg

debline='deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main'
echo "$debline" | tee /etc/apt/sources.list.d/dart_stable.list

apt-get update && apt-get install dart -y

