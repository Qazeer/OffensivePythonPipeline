#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-windows:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

python -m pip install --upgrade pip
pip install --upgrade setuptools

cd /host_build/enum4linuxng/

# Install dependencies
sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
apt-get clean -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*
apt-get update -y
apt-get install -y smbclient
pip install wheel pyyaml ldap3
pip install -r requirements.txt

echo "# -*- coding:utf-8 -*-

from PyInstaller.utils.hooks import copy_metadata

datas = copy_metadata('impacket')" > ./hook-impacket.py

nmblookup_path=$(which nmblookup)
net_path=$(which net)
rpcclient_path=$(which rpcclient)
smbclient_path=$(which smbclient)

if ! ([ -x "($nmblookup_path -h)" ] || [ -x "($net_path)" ] || [ -x "$rpcclient_path" ] || [ -x "$smbclient_path" ]); then echo "The nmblookup / net / rpcclient / smbclient binaries must be in PATH" && exit 1; fi

# Create standalone executables
pyinstaller --add-binary="$nmblookup_path:." --add-binary="$net_path:." --add-binary="$rpcclient_path:." --add-binary="$smbclient_path:." --onefile --distpath /tmp/out --clean -F /host_build/enum4linuxng/enum4linux-ng.py

# Export the compiled binaries
mv /tmp/out/enum4linux-ng /host_build/enum4linuxng_linux
