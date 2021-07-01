#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-linux:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

python -m pip install --upgrade pip

# Install cube0x0's impacket
cd /printnightmare/impacket-cube0x0
pip install .

# Create standalone executables
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /printnightmare/CVE-2021-1675/CVE-2021-1675.py

# Export the compiled binaries
mv /tmp/out/CVE-2021-1675 /printnightmare/CVE-2021-1675_linux