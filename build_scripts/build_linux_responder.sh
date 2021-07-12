#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-linux:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

python -m pip install --upgrade pip

# Install Responder / MultiRelay dependencies.
sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
apt-get clean -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*
apt-get update -y
apt-get install -y libreadline-gplv2-dev libncursesw5-dev libncurses5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
pip install pycryptodome readline

# Updates the directory in which Responder loads its Responder.conf file.
cp -r /host_build/Responder /Responder
cd /Responder
sed -i "s/os.path.dirname(__file__)/'.'/" settings.py

# Create standalone binaries.
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /Responder/Responder.py
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /Responder/tools/MultiRelay.py

# Export the compiled binaries and Responder default configuration file.
mv /tmp/out/Responder /host_build/Responder_linux
mv /tmp/out/MultiRelay /host_build/MultiRelay_linux
cp /Responder/Responder.conf /host_build/Responder.conf