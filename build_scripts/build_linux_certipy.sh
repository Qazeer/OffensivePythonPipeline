#!/bin/bash

# Inspired from: https://github.com/ropnop/impacket_static_binaries

# This script is intended to be run in the cdrx/pyinstaller-linux:latest Docker image
[[ ! -f /.dockerenv ]] && echo "Do not run this script outside of the docker image!" && exit 1

set -euo pipefail

# Normalize working dir
ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
cd "${ROOT}"

# Install Python3.9 as required by Certipy
if [[ ! -d /tmp/python3.9_source ]]
then
    sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
    apt-get update -y
    apt-get install -y build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev python3-dev libffi-dev libsqlite3-dev zlib1g-dev libbz2-dev liblzma-dev lzma lzma-dev
    # Build and install needed openssl version from sources.
    cd /usr/src
    curl -k https://www.openssl.org/source/openssl-1.1.1.tar.gz | tar xz
    cd openssl-1.1.1
    ./config shared --prefix=/usr/ zlib-dynamic
    make -j8
    make install -j8
    mkdir lib
    cp *.so ./lib 2>/dev/null || :
    cp *.so.1.1 ./lib 2>/dev/null || :
    cp *.a ./lib 2>/dev/null || :
    cp *.pc ./lib 2>/dev/null || :
    export LD_LIBRARY_PATH=/usr/src/openssl-1.1.1/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    # Build and install Python version from sources.
    mkdir /usr/src/Python3.9 && cd /usr/src/Python3.9
    git init
    git remote add -t 3.9 -f origin https://github.com/python/cpython.git
    git checkout 3.9
    ./configure --with-openssl=/usr/src/openssl-1.1.1 --enable-optimizations --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
    make -j8
    make altinstall -j8
fi

python3.9 -m pip install --upgrade pip

# Install impacket
cd /host_build/impacket-SecureAuthCorp/
python3.9 -m pip install .

# Certipy does not specify a requirements file, creating one using setup.py egg_info.
cd /host_build/Certipy/
python3.9 setup.py egg_info
python3.9 -m pip install `grep -v '^\[' *.egg-info/requires.txt`

# Create standalone executables
python3.9 -m pip install pyinstaller==4.3
python3.9 -m PyInstaller --specpath /tmp/spec --workpath /tmp/build --distpath /tmp/out --clean -F /host_build/Certipy/certipy/entry.py

# Export the compiled binaries
mv /tmp/out/entry /host_build/certipy_linux
