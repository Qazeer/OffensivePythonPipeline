#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-linux:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

python -m pip install --no-cache-dir --upgrade pip
pip install --no-cache-dir --upgrade setuptools

# Install pypykatz requirements.
cp -r /host_build/pypykatz /pypykatz && cd /pypykatz
pip install --upgrade --no-cache-dir minidump minikerberos aiowinreg aiosmb msldap winacl
python setup.py install

# Create standalone executables
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /host_build/pypykatz/pypykatz/__amain__.py

# Export the compiled binaries
mv /tmp/out/__amain__ /host_build/pypykatz_linux