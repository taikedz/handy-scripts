# Things needed on a Windows installation

There are two basic tools I tend to find I need:

* chocolatey (and local admin)
* WSL2 with Ubuntu

## Chocolatey

* Get an Admin PowerShell session

Run this:

```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

## Chocolatey packages

```ps1
choco install -y virtualbox vagrant vscode firefox gimp audacity vlc python3 git
```

## WSL

Install WSL2 and the latest Ubuntu LTS

Inside there, install APT packages and get personal common resources

```sh

ln -s /mnt/c/Users/$(whoami)/ ./windows

sudo apt-get update && sudo apt-get install -y git htop tmux vim python3 python3-pip python3-virtualenv podman

sudo snap install --classic rustup
rustup toolchain install stable

sudo snap install --classic go

mkdir -p git/github.com/taikedz
cd git/github.com/taikedz

ghbase="$http://github.com/taikedz"

git clone "$ghbase/handy-scripts"
(
    cd handy-scripts
    ./install.sh all
    sudo ./install.sh config
)

git clone "$ghbase/alpacka"
(cd alpacka; bash install.sh)

git clone "$ghbase/git-shortcuts"
(cd git-shortcuts; bash install.sh)
```
