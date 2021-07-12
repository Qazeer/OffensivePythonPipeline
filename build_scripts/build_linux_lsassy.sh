#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-linux:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir.
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

python -m pip install --upgrade pip

# Install impacket.
cd /host_build/impacket-SecureAuthCorp/
pip install .

# Install lsassy requirements.
cp -r /host_build/lsassy /lsassy && cd /lsassy
pip install -r requirements.txt
pip install lsassy

# Creates PyInstaller hooks for lsassy.
mkdir -p /lsassy/hooks/
echo "# -*- coding:utf-8 -*-

from PyInstaller.utils.hooks import collect_all

datas, binaries, hiddenimports = collect_all('lsassy')" > /lsassy/hooks/hook-lsassy.py

# Create standalone executable.
pyinstaller -D --additional-hooks-dir=/lsassy/hooks/ --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /lsassy/lsassy/core.py

# Export the compiled binaries.
mv /tmp/out/core /host_build/lsassy_linux
