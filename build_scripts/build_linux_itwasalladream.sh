#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-linux:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

python -m pip install --upgrade pip

# Force install of the last impacket version (to make sure the version used has the necessary MS-PAR implementation ).
pip uninstall impacket
cd /host_build/impacket-SecureAuthCorp/
pip install .

cp -r /host_build/ItWasAllADream /ItWasAllADream
cd /ItWasAllADream
sed -i '1s/^/import encodings.idna\n/' /ItWasAllADream/itwasalladream/__main__.py
# Dirty fix: removes already installed impacket package from requirements.txt (as it generates error "Can't verify hashes for these requirements because we don't have a way to hash version control repositories").
sed -i '/impacket/d' /ItWasAllADream/requirements.txt
pip install -r requirements.txt
# Call main() as ItWasAllADream does not define "if __name__ == "__main__"
echo -e "\n\nmain()" >> /ItWasAllADream/itwasalladream/__main__.py

# Create standalone executables
pyinstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /ItWasAllADream/itwasalladream/__main__.py

# Export the compiled binary.
mv /tmp/out/__main__ /host_build/ItWasAllADream_linux