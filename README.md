# OffensivePythonPipeline

This repository contains the following static standalone binaries of Python
offensive tools:

| Tool | Operating System(s) | Binary output(s) |
|------|------------------|---------------|
| [Certipy](https://github.com/ly4k/Certipy) | Linux / Windows x64 | `certipy_linux` <br/> `certipy_windows.exe`  |
| [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec) | Linux / Windows x64 | `crackmapexec_linux` <br/> `crackmapexec_windows.exe`  |
| [dirkjanm's CVE-2020-1472 (ZeroLogon)](https://github.com/dirkjanm/CVE-2020-1472) | Linux / Windows x64 | `cve-2020-1472-exploit_linux` <br/> `restorepassword_linux` <br/><br/> `cve-2020-1472-exploit_windows.exe` <br/> `restorepassword_windows.exe` |
| [cube0x0's CVE-2021-1675 (PrintNightmare)](https://github.com/cube0x0/CVE-2021-1675) | Linux / Windows x64 | `CVE-2021-1675_linux` <br/> `CVE-2021-1675_windows.exe` |
| [Ridter's noPac (CVE-2021-42278 and CVE-2021-42287)](https://github.com/Ridter/noPac) | Linux / Windows x64 | `noPac_scanner_linux` <br> `noPac_linux` <br><br> `noPac_scanner_windows.exe` <br> `noPac_windows.exe` |
| [enum4linux-ng](https://github.com/cddmp/enum4linux-ng) | Linux x64 (with the `samba tools` installed) | `enum4linuxng_linux` |
| [gMSADumper](https://github.com/micahvandeusen/gMSADumper) | Linux / Windows x64 | `gMSADumper_linux` <br/> `gMSADumper_windows.exe`  |
| [impacket](https://github.com/SecureAuthCorp/impacket) | Linux / Windows x64 | Current (as of 2021-07-11) impacket's examples scripts |
| [ItWasAllADream](https://github.com/byt3bl33d3r/ItWasAllADream) | Linux / Windows x64 | `ItWasAllADream_linux` <br/> `ItWasAllADream_windows.exe` |
| [LaZagne](https://github.com/AlessandroZ/LaZagne) | Linux / Windows x64 | `lazagne_linux` <br/> `lazagne_windows.exe` |
| [lsassy](https://github.com/Hackndo/lsassy) | Linux / Windows x64 | `lsassy_linux` <br/> `lsassy_windows.exe` |
| [Pachine (CVE-2021-42278)](https://github.com/ly4k/Pachine) | Linux / Windows x64 | `pachine_linux` <br/> `pachine_windows.exe` |
| [pypykatz](https://github.com/skelsec/pypykatz) | Linux / Windows x64 | `pypykatz_linux` <br/> `pypykatz_windows.exe` |
| [pywhisker](https://github.com/ShutdownRepo/pywhisker) | Linux / Windows x64 | `pywhisker_linux` <br/> `pywhisker_windows.exe` |
| [Responder](https://github.com/lgandx/Responder) | Linux x64 (experimental) | `Responder_linux` <br/> `MultiRelay_linux` |
| [smartbrute](https://github.com/ShutdownRepo/smartbrute) | Linux / Windows x64 | `smartbrute_linux` <br/> `smartbrute_windows.exe` |
| [SMBMap](https://github.com/ShawnDEvans/smbmap) | Linux x64 | `smbmap_linux` |

**Credits to [maaaaz](https://github.com/maaaaz) and
[ropnop](https://blog.ropnop.com/) for the original idea and inspiration.**

### Build process

The Windows and Linux standalone binaries are built with
[PyInstaller](http://www.pyinstaller.org/), executed in Docker containers from
Windows.

The Linux build process is heavily based on work from [ropnop's
impacket_static_binaries](https://github.com/ropnop/impacket_static_binaries)
and uses [cdrx's PyInstaller Linux docker
image](https://github.com/cdrx/docker-pyinstaller). The Linux binaries are
built in Ubuntu 12.04 running Glibc 2.15 and should thus be compatible with any
version of Glibc newer than 2.15.

The Windows build process relies on a Windows Docker image provided by
[Microsoft](https://hub.docker.com/publishers/microsoftowner). `Python 3.8.9`
and `PyInstaller` are installed at runtime in the container.

In order to limit overhead for successive builds:
  - a persistent container named `OffensivePythonPipelineWindows` is created
    whenever calling the `windows` target. The container is used for the
    consecutive builds and deleted upon completion of the process.
  - a temporary image is created whenever calling the `linux` target. The image
    is used for the consecutive builds, with each new container's changes
    applied to the image. The image is deleted upon completion of the build
    process.

###### Build the binaries yourself

The binaries can be build directly from sources using the provided `Makefile`
after retrieving the `mcr.microsoft.com/dotnet/framework/sdk` and / or
`cdrx/pyinstaller-linux` Docker images. The `Makefile` targets must be executed
in a Linux distribution using `Windows Subsystem for Linux (WSL) 2`.

The newly compiled binaries will be placed in the `binaries` folder.

The `PROJECT_PATH_LINUX` and `PROJECT_PATH_WINDOWS` variables must be set
accordingly in the `Makefile`. For example:

```
PROJECT_PATH_LINUX=/mnt/c/no_scan/OffensivePythonPipeline
PROJECT_PATH_WINDOWS=C:\no_scan\OffensivePythonPipeline
```

`Makefile` usage:

```
# Retrieves the required Docker images.
& "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchLinuxEngine
docker pull cdrx/pyinstaller-linux

& "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchWindowsEngine
docker pull mcr.microsoft.com/dotnet/framework/sdk

# Help message listing the supported Makefile targets.
make help

all:                      Compiles all binaries for both Windows and Linux.

windows:                  Compiles all Windows binaries.
windows_certipy:          Compiles Windows binary for ly4k's Certipy.
windows_crackmapexec:     Compiles Windows binary for byt3bl33d3r's CrackMapExec.
windows_gmsadumper:       Compiles Windows binary for micahvandeusen's gMSADumper.
windows_impacket:         Compiles Windows binaries for SecureAuthCorp's impacket examples.
windows_itwasalladream:   Compiles Windows binary for byt3bl33d3r's ItWasAllADream.
windows_lazagne:          Compiles Windows binary for AlessandroZ's LaZagne.
windows_lsassy:           Compiles Windows binary for Hackndo's lsassy.
windows_nopac:            Compiles Windows binary for Ridter's noPac.
windows_pachine:          Compiles Windows binary for ly4k's Pachine.
windows_printnightmare:   Compiles Windows binary for cube0x0's CVE-2021-1675.
windows_pypykatz:         Compiles Windows binary for skelsec's pypykatz.
windows_pywhisker:        Compiles Windows binary for ShutdownRepo's pywhisker.
windows_smartbrute:       Compiles Windows binaries for ShutdownRepo's smartbrute.
windows_zerologon:        Compiles Windows binaries for dirkjanm's CVE-2020-1472.

linux:                    Compiles all Linux binaries.
linux_certipy:            Compiles Linux binary for ly4k's Certipy.
linux_crackmapexec:       Compiles Linux binary for byt3bl33d3r's CrackMapExec.
linux_gmsadumper:         Compiles Linux binary for micahvandeusen's gMSADumper.
linux_enum4linuxng:       !! Still depends on nmblookup / net / rpcclient / smbclient !! Compiles Linux binary for cddmp's enum4linux-ng.
linux_impacket:           Compiles Linux binaries for SecureAuthCorp's impacket examples.
linux_itwasalladream:     Compiles Linux binary for byt3bl33d3r's ItWasAllADream.
linux_lazagne:            Compiles Linux binary for AlessandroZ's LaZagne.
linux_lsassy:             Compiles Linux binary for Hackndo's lsassy.
linux_nopac:              Compiles Linux binary for Ridter's noPac.
linux_pachine:            Compiles Linux binary for ly4k's Pachine.
linux_printnightmare:     Compiles Linux binary for cube0x0's CVE-2021-1675.
linux_pypykatz:           Compiles Linux binary for skelsec's pypykatz.
linux_pywhisker:          Compiles Linux binary for ShutdownRepo's pywhisker.
linux_responder:          Compiles Linux binaries for Responder.
linux_smartbrute:         Compiles Linux binaries for ShutdownRepo's smartbrute.
linux_smbmap:             Compiles Linux binary for ShawnDEvans' smbmap.
linux_zerologon:          Compiles Linux binaries for dirkjanm's CVE-2020-1472.

test:                     Executes all the Windows / Linux binaries
                            (for a manual review of errors use make test 1>/dev/null).
clean:                    Clean build artefacts by deleting the build folder.
```

### Known issues

  - Pressing the Enter key may sometimes be necessary to finish the execution
    of the `CrackMapExec` Windows binary ¯\\_(ツ)_/¯.

  - `enum4linux-ng` still requires the `samba tools` (`nmblookup` / `net` /
    `rpcclient` / `smbclient`) to be installed on the host.
    This is likely due to the `PyInstaller` extract folder (`_MEIxxxxxx`) not
    being in `PATH` for the subprocess calls made by `enum4linux-ng`.

  - `SMBMap` is non-functional as a Windows standalone binary (endless
    printing of the usage helper).

  - `impacket`'s `nmapAnswerMachine` is missing the `uncrc32` module (Linux /
    Windows) and `impacket`'s `sniff` / `split` are missing the `pcapy`
    module (Linux / Windows).

  - `impacket`'s `ntlmrelayx` / `smbrelayx` / `sniffer` standalone binaries
    fail with error `WinError 10013` on Windows and `NotImplementedError:
    Can't perform this operation for unregistered loader type` on Linux.
   
More comprehensive tests of the binaries are underway, if you find a bug
please feel free to open an issue.

###### Temporarily fixed issues

  - The `PyInstaller` spec file in the `CrackMapExec` repository is missing
    an hidden import for `impacket.ldap`. The spec file is automatically
    modified in the build scripts to add the hidden import.  
    [Issue opened `CrackMapExec`-side](https://github.com/byt3bl33d3r/CrackMapExec/issues/475).

  - `CrackMapExec` requires the unmaintained `pycrypto` module as it is
    required by `pywerview`. `pycrypto` causes issues for standalone build on
    Windows due to incompatibility with recent `Build Tools for Visual
    Studio`). The requirement is automatically removed from `pywerview` and
    `CrackMapExec` in the build scripts.  
    [Issue opened `pywerview`-side](https://github.com/the-useless-one/pywerview/issues/44).

  - `CrackMapExec`'s `lsassy` module is non functional on Linux / Windows x64
    (error message `The  'lsassy' distribution was not found and is required
    by the application`) using the repository spec file. A custom `PyInstaller`
    hook for `lsassy` is added through the build scripts and the spec file is
    automatically modified accordingly.   
    [Issue previously opened `CrackMapExec`-side](https://github.com/byt3bl33d3r/CrackMapExec/issues/456).


### Tools TODO
  - [Responder-Windows](https://github.com/lgandx/Responder-Windows)
  - [patator](https://github.com/lanjelot/patator)
  - [sqlmap](https://github.com/sqlmapproject/sqlmap)
  - [WebclientServiceScanner](https://github.com/Hackndo/WebclientServiceScanner)
  - [RDPassSpray](https://github.com/xFreed0m/RDPassSpray)
