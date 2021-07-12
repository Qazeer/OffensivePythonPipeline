#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries
# Impacket Linux build script source: https://github.com/ropnop/impacket_static_binaries/blob/master/build_scripts/build_linux.sh

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

# Hardcode UTF-8 in shells.
sed -r -i.bak 's/sys\.std(in|out)\.encoding/"UTF-8"/g' /host_build/impacket-SecureAuthCorp/examples/*exec.py  

# Create standalone executables
for i in /host_build/impacket-SecureAuthCorp/examples/*.py
do
    pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F $i
done

# Rename binaries and move
mkdir -p /host_build/impacket
find /tmp/out/ -type f -exec mv {} {}_linux \;
mv /tmp/out/*_linux /host_build/impacket/

# Restore backup file
for fn in /host_build/impacket-SecureAuthCorp/examples/*.bak; do mv -f "${fn}" "${fn%%.bak}"; done