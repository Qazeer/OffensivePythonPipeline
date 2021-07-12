#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-linux:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

python -m pip install --upgrade pip

# Install impacket
cd /host_build/impacket-SecureAuthCorp
pip install .

cd /host_build/smbmap/

# Installing and creating a venv
python -m pip install virtualenv
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

echo "# -*- coding:utf-8 -*-

from PyInstaller.utils.hooks import copy_metadata

datas = copy_metadata('impacket')" > ./hook-impacket.py

# Create standalone executable
pyinstaller --additional-hooks-dir=. --paths /host_build/smbmap/venv/lib/python3.7/site-packages --onefile --distpath /tmp/out --clean -F smbmap.py

# Export the compiled binaries
mv /tmp/out/smbmap /host_build/smbmap_linux