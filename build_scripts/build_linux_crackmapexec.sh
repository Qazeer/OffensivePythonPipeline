#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-linux:latest Docker image.
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir.
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

python -m pip install --upgrade pip

# Install impacket
cd /host_build/impacket-SecureAuthCorp/
pip install .

# Install CrackMapExec dependancies.
cp -r /host_build/CrackMapExec /CrackMapExec
cd /CrackMapExec
pip install -r ./requirements.txt
pip install lsassy

# Creates PyInstaller hooks for lsassy.
mkdir -p /CrackMapExec/hooks/
echo "# -*- coding:utf-8 -*-

from PyInstaller.utils.hooks import collect_all

datas, binaries, hiddenimports = collect_all('lsassy')" > /CrackMapExec/hooks/hook-lsassy.py

# Build the standalone crackmapexec binary after adding the hidden import for impacket.ldap.
# May become unnecessary if issue https://github.com/byt3bl33d3r/CrackMapExec/issues/475 is fixed.
sed "s/'impacket.tds'/'impacket.ldap.ldap', 'impacket.tds'/" crackmapexec.spec > crackmapexec-updated.spec
sed -i "s/hookspath=\[]/hookspath=\['hooks']/" crackmapexec-updated.spec
pyinstaller --onefile --clean -F crackmapexec-updated.spec

# Export the compiled binaries
mv /CrackMapExec/dist/crackmapexec /host_build/crackmapexec_linux