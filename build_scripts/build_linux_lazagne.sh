#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-linux:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir.
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

python -m pip install --upgrade pip

# Install LaZagne requirements.
cp -r /host_build/lazagne /lazagne && cd /lazagne
pip install -r requirements.txt

# Create standalone executable.
cd /lazagne/Linux
pyinstaller --onefile --clean -F laZagne.spec

# Export the compiled binaries.
mv /lazagne/Linux/dist/laZagne /host_build/lazagne_linux
