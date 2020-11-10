#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

set -euo pipefail

# This script is intended to be run in the cdrx/pyinstaller-windows:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

# Install impacket
cd /zerologon/impacket-master/
pip install .

# Create standalone executables
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /zerologon/CVE-2020-1472/cve-2020-1472-exploit.py
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /zerologon/CVE-2020-1472/restorepassword.py

# Export the compiled binaries
cp /tmp/out/cve-2020-1472-exploit.exe /zerologon/
cp /tmp/out/restorepassword.exe /zerologon/
