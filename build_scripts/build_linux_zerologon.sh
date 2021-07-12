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

# Create standalone executables
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /host_build/CVE-2020-1472/cve-2020-1472-exploit.py
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /host_build/CVE-2020-1472/restorepassword.py

# Export the compiled binaries
mv /tmp/out/cve-2020-1472-exploit /host_build/cve-2020-1472-exploit_linux
mv /tmp/out/restorepassword /host_build/restorepassword_linux
