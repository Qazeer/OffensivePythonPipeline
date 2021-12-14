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
cd /host_build/impacket-SecureAuthCorp/
pip install .

# gMSADumper does not specify a requirements file, creating one using setup.py egg_info.
cd /host_build/gMSADumper/
pip freeze > /host_build/gMSADumper/requirements.txt
pip install -r /host_build/gMSADumper/requirements.txt

# Create standalone executables
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /host_build/gMSADumper/gMSADumper.py

# Export the compiled binaries
mv /tmp/out/gMSADumper /host_build/gMSADumper_linux
