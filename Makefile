.PHONY: all windows windows_certipy windows_crackmapexec windows_gmsadumper windows_impacket windows_itwasalladream windows_lazagne windows_lsassy windows_pachine windows_printnightmare windows_pypykatz windows_pywhisker windows_zerologon linux linux_certipy linux_crackmapexec linux_enum4linuxng linux_gmsadumper linux_impacket linux_itwasalladream linux_lazagne linux_lsassy linux_pachine linux_printnightmare linux_pypykatz linux_pywhisker linux_responder linux_smbmap linux_zerologon clean test
THIS_FILE := $(lastword $(MAKEFILE_LIST))

# Should both be updated to match your environment.
PROJECT_PATH_LINUX=/mnt/c/Users/User/OffensivePythonPipeline
PROJECT_PATH_WINDOWS=C:\Users\User\OffensivePythonPipeline

BUILD_FOLDER=tmp_build
OUTPUT_FOLDER=binaries

DOCKER_CLI_PATH=C:\Program Files\Docker\Docker\DockerCli.exe

DOCKER_WINDOWS_CONTAINER=OffensivePythonPipelineWindows
DOCKER_WINDOWS_IMAGE=mcr.microsoft.com/dotnet/framework/sdk
DOCKER_WINDOWS_ENTRYPOINT_FILE=build.ps1
DOCKER_WINDOWS_BUILD_FOLDER=c:\host_build
DOCKER_WINDOWS_RUN_SINGLE=docker run --rm -v "$(PROJECT_PATH_WINDOWS)\$(BUILD_FOLDER):$(DOCKER_WINDOWS_BUILD_FOLDER)" -w "$(DOCKER_WINDOWS_BUILD_FOLDER)" $(DOCKER_WINDOWS_IMAGE) powershell -NoP -ExecutionPolicy Bypass -File $(DOCKER_WINDOWS_BUILD_FOLDER)\$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
DOCKER_WINDOWS_CREATE=docker run -t -d --name $(DOCKER_WINDOWS_CONTAINER) -v "$(PROJECT_PATH_WINDOWS)\$(BUILD_FOLDER):$(DOCKER_WINDOWS_BUILD_FOLDER)" -w "$(DOCKER_WINDOWS_BUILD_FOLDER)" $(DOCKER_WINDOWS_IMAGE)
DOCKER_WINDOWS_DELETE=docker rm --force $(DOCKER_WINDOWS_CONTAINER)
DOCKER_WINDOWS_EXEC=docker exec -t $(DOCKER_WINDOWS_CONTAINER) powershell -NoP -ExecutionPolicy Bypass -File $(DOCKER_WINDOWS_BUILD_FOLDER)\$(DOCKER_WINDOWS_ENTRYPOINT_FILE)

DOCKER_LINUX_CONTAINER=OffensivePythonPipelineLinux
DOCKER_LINUX_IMAGE=cdrx/pyinstaller-linux
DOCKER_LINUX_ENTRYPOINT_FILE=build.sh
DOCKER_LINUX_BUILD_FOLDER=/host_build
DOCKER_LINUX_RUN_SINGLE=docker run --rm -v "${PROJECT_PATH_LINUX}/$(BUILD_FOLDER):$(DOCKER_LINUX_BUILD_FOLDER)" -w "$(DOCKER_LINUX_BUILD_FOLDER)" $(DOCKER_LINUX_IMAGE) $(DOCKER_LINUX_BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
DOCKER_LINUX_CREATE=docker create -it --name $(DOCKER_LINUX_CONTAINER) $(DOCKER_LINUX_IMAGE) && docker commit $(DOCKER_LINUX_CONTAINER) $(DOCKER_LINUX_IMAGE)-tmp && docker rm $(DOCKER_LINUX_CONTAINER)
DOCKER_LINUX_DELETE=docker rm --force $(DOCKER_LINUX_CONTAINER)
DOCKER_LINUX_EXEC=docker run --name $(DOCKER_LINUX_CONTAINER) -v "${PROJECT_PATH_LINUX}/$(BUILD_FOLDER):$(DOCKER_LINUX_BUILD_FOLDER)" -w "$(DOCKER_LINUX_BUILD_FOLDER)" $(DOCKER_LINUX_IMAGE)-tmp $(DOCKER_LINUX_BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE) && docker commit $(DOCKER_LINUX_CONTAINER) $(DOCKER_LINUX_IMAGE)-tmp && docker rm $(DOCKER_LINUX_CONTAINER)

PYTHON_INSTALLER_URL="https://www.python.org/ftp/python/3.8.9/python-3.8.9.exe"
PYTHON_INSTALLER_LAST_URL="https://www.python.org/ftp/python/3.9.9/python-3.9.9.exe"
MS_CPP_REDIS_x86_URL="http://download.microsoft.com/download/5/B/C/5BC5DBB3-652D-4DCE-B14A-475AB85EEF6E/vcredist_x86.exe"
MS_CPP_REDIS_x64_URL="https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe"

CERTIPY_URL="https://github.com/ly4k/Certipy/archive/main.zip"
CRACKMAPEXEC_URL="https://github.com/byt3bl33d3r/CrackMapExec/archive/master.zip"
ENUM4LINUXNG_URL="https://github.com/cddmp/enum4linux-ng/archive/master.zip"
GMSADUMPER_URL="https://github.com/micahvandeusen/gMSADumper/archive/main.zip"
IMPACKET_URL="https://github.com/SecureAuthCorp/impacket/archive/master.zip"
ITWASALLADREAM_URL="https://github.com/byt3bl33d3r/ItWasAllADream/archive/master.zip"
LAZAGNE_URL="https://github.com/AlessandroZ/LaZagne/archive/master.zip"
LSASSY_URL="https://github.com/Hackndo/lsassy/archive/master.zip"
NOPAC_URL="https://github.com/Ridter/noPac/archive/main.zip"
PACHINE_URL="https://github.com/ly4k/Pachine/archive/main.zip"
PRINTNIGHTMARE_URL="https://github.com/cube0x0/CVE-2021-1675/archive/main.zip"
PYPYKATZ_URL="https://github.com/skelsec/pypykatz/archive/master.zip"
PYWERVIEW_URL="https://github.com/the-useless-one/pywerview/archive/master.zip"
RESPONDER_URL="https://github.com/lgandx/Responder/archive/master.zip"
SMARTBRUTE_URL="https://github.com/ShutdownRepo/smartbrute/archive/main.zip"
SMBMAP_URL="https://github.com/ShawnDEvans/smbmap/archive/master.zip"
PYWHISKER_URL="https://github.com/ShutdownRepo/pywhisker/archive/main.zip"
ZEROLOGON_URL="https://github.com/dirkjanm/CVE-2020-1472/archive/master.zip"

help:                    ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

_python_download:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/python.exe" ]; then wget --no-check-certificate -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/python.exe $(PYTHON_INSTALLER_URL); fi

_python_last_download:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/python_last.exe" ]; then wget --no-check-certificate -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/python_last.exe $(PYTHON_INSTALLER_LAST_URL); fi

_ms_cpp_redis_download:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/VC_redist.x64.exe" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/VC_redist.x64.exe $(MS_CPP_REDIS_x64_URL); fi
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/VC_redist.x86.exe" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/VC_redist.x86.exe $(MS_CPP_REDIS_x86_URL); fi

_impacket_download:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/impacket-SecureAuthCorp.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/impacket-SecureAuthCorp.zip $(IMPACKET_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/impacket-SecureAuthCorp" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/impacket-SecureAuthCorp.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/impacket-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/impacket-SecureAuthCorp; fi


# Swith the Docker engine to Windows.
_docker_switch_windows:
	echo "Switching to Docker Windows engine..."
	@powershell.exe -c "& '$(DOCKER_CLI_PATH)' -SwitchWindowsEngine"
	@powershell.exe -c "timeout 10"

# Swith the Docker engine to Linux.
_docker_switch_linux:
	echo "Switching to Docker Linux engine..."
	@powershell.exe -c "& '$(DOCKER_CLI_PATH)' -SwitchLinuxEngine"
	@powershell.exe -c "timeout 10"

# Start a detached container for consecutive Windows builds (in order to avoid multiple time-consuming installations).
_docker_windows_create:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@powershell.exe -c 'If (docker ps -a --filter "name=$(DOCKER_WINDOWS_CONTAINER)" | Select-String -Quiet -Pattern "$(DOCKER_WINDOWS_CONTAINER)") { $(DOCKER_WINDOWS_DELETE) }'
	@powershell.exe -c '$(DOCKER_WINDOWS_CREATE)'

_docker_windows_rm:
	@powershell.exe -c '$(DOCKER_WINDOWS_DELETE)'

# Check wether the OffensivePythonPipeline Linux container is already running and if so execute in it. Otherwise run a new one-time container.
_docker_windows_run:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@powershell.exe -c 'If (docker ps --filter "name=$(DOCKER_WINDOWS_CONTAINER)" | Select-String -Quiet -Pattern "$(DOCKER_WINDOWS_CONTAINER)") { Write-Host "Executing command in already running container..."; $(DOCKER_WINDOWS_EXEC) } else { Write-Host "Starting new container..."; $(DOCKER_WINDOWS_RUN_SINGLE) }'

# Start a detached container for consecutive Linux builds (in order to avoid multiple time-consuming installations).
_docker_linux_create:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	if [ "$$(docker ps -a --filter "name=$(DOCKER_LINUX_CONTAINER)" | grep "$(DOCKER_LINUX_CONTAINER)")" ]; then $(DOCKER_LINUX_DELETE); fi
	if [ "$$(docker image ls $(DOCKER_LINUX_IMAGE)-tmp | grep "$(DOCKER_LINUX_IMAGE)-tmp")" ]; then docker image rm --force $(DOCKER_LINUX_IMAGE)-tmp; fi
	$(DOCKER_LINUX_CREATE)

_docker_linux_rm:
	$(DOCKER_LINUX_DELETE)
	docker image rm --force $(DOCKER_LINUX_IMAGE)-tmp

# Check wether the OffensivePythonPipeline Linux container is already running and if so execute in it. Otherwise run a new one-time container.
_docker_linux_run:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	if [ "$$(docker image ls $(DOCKER_LINUX_IMAGE)-tmp | grep "$(DOCKER_LINUX_IMAGE)-tmp")" ]; then echo "Executing command using already commited image..." && $(DOCKER_LINUX_EXEC); else echo "Starting new container..." && $(DOCKER_LINUX_RUN_SINGLE); fi

all:                     ## Compiles all binaries for both Windows and Linux.
all: windows linux

windows:                 ## Compiles all Windows binaries.
windows: _docker_switch_windows _docker_windows_create windows_crackmapexec windows_gmsadumper windows_lsassy windows_lazagne windows_zerologon windows_printnightmare windows_pachine windows_pywhisker windows_smartbrute windows_itwasalladream windows_pypykatz windows_impacket windows_certipy windows_nopac _docker_windows_rm

windows_certipy:         ## Compiles Windows binary for ly4k's Certipy.
	@$(MAKE) -f $(THIS_FILE) _python_last_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_certipy.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy.zip $(CERTIPY_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/certipy_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_crackmapexec:    ## Compiles Windows binary for byt3bl33d3r's CrackMapExec.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_crackmapexec.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview.zip $(PYWERVIEW_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview; fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CrackMapExec" ]; then cd $(PROJECT_PATH_LINUX) && git clone --recursive https://github.com/byt3bl33d3r/CrackMapExec $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CrackMapExec; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/crackmapexec_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_gmsadumper:      ## Compiles Windows binary for micahvandeusen's gMSADumper.
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_gmsadumper.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper.zip $(GMSADUMPER_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_impacket:        ## Compiles Windows binaries for SecureAuthCorp's impacket examples.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_impacket.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/impacket
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/impacket/*_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/impacket/

windows_itwasalladream:  ## Compiles Windows binary for byt3bl33d3r's ItWasAllADream.
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_itwasalladream.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream.zip $(ITWASALLADREAM_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_lazagne:         ## Compiles Windows binary for AlessandroZ's LaZagne.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _python_download _ms_cpp_redis_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_lazagne.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne.zip $(LAZAGNE_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_lsassy:          ## Compiles Windows binary for Hackndo's lsassy.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_lsassy.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy.zip $(LSASSY_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_nopac:           ## Compiles Windows binary for Ridter's noPac.
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_nopac.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac.zip $(NOPAC_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac_*.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_pachine:         ## Compiles Windows binary for ly4k's Pachine.
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_pachine.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine.zip $(PACHINE_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pachine_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_printnightmare:  ## Compiles Windows binary for cube0x0's CVE-2021-1675.
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_printnightmare.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675.zip $(PRINTNIGHTMARE_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_pypykatz:        ## Compiles Windows binary for skelsec's pypykatz.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _python_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_pypykatz.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz.zip $(PYPYKATZ_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_pywhisker:       ## Compiles Windows binary for Shutdown's pywhisker.
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_pywhisker.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker.zip $(PYWHISKER_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

# ! Not functional ! Compiles Windows binaries for Responder.
windows_responder:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _python_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_responder.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder.zip $(RESPONDER_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/Responder/
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/Responder/
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/MultiRelay_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/Responder/
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder.conf $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/Responder/

windows_smartbrute:      ## Compiles Windows binaries for Shutdown's smartbrute.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_smartbrute.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute.zip $(SMARTBRUTE_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

# ! Non-functionnal ! Compiles Windows binary for ShawnDEvans' smbmap.
windows_smbmap:
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_smbmap.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap.zip $(SMBMAP_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

windows_zerologon:       ## Compiles Windows binaries for dirkjanm's CVE-2020-1472.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _python_download _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_windows_zerologon.ps1 $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_WINDOWS_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472.zip $(ZEROLOGON_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472; fi
	@$(MAKE) -f $(THIS_FILE) _docker_windows_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/cve-2020-1472-exploit_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/restorepassword_windows.exe $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux:                   ## Compiles all Linux binaries.
linux: _docker_switch_linux _docker_linux_create linux_crackmapexec linux_gmsadumper linux_lsassy linux_lazagne linux_zerologon linux_pachine linux_printnightmare linux_pywhisker linux_smartbrute linux_itwasalladream linux_enum4linuxng linux_pypykatz linux_smbmap linux_responder linux_impacket linux_certipy linux_nopac _docker_linux_rm

linux_certipy:           ## Compiles Linux binary for ly4k's Certipy.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_certipy.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy.zip $(CERTIPY_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Certipy; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/certipy_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_crackmapexec:      ## Compiles Linux binary for byt3bl33d3r's CrackMapExec.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_crackmapexec.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview.zip $(PYWERVIEW_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywerview; fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CrackMapExec" ]; then cd $(PROJECT_PATH_LINUX) && git clone --recursive https://github.com/byt3bl33d3r/CrackMapExec $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CrackMapExec; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/crackmapexec_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_gmsadumper:        ## Compiles Linux binary for micahvandeusen's gMSADumper.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_gmsadumper.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper.zip $(GMSADUMPER_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/gMSADumper_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_enum4linuxng:      ## !! Still depends on nmblookup / net / rpcclient / smbclient !! Compiles Linux binary for cddmp's enum4linux-ng.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_enum4linuxng.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/enum4linuxng.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/enum4linuxng.zip $(ENUM4LINUXNG_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/enum4linuxng" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/enum4linuxng.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/enum4linux-ng-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/enum4linuxng; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/enum4linuxng_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_impacket:          ## Compiles Linux binaries for SecureAuthCorp's impacket examples.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_impacket.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/impacket
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/impacket/*_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/impacket/

linux_itwasalladream:    ## Compiles Linux binary for byt3bl33d3r's ItWasAllADream. 
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_itwasalladream.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream.zip $(ITWASALLADREAM_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/ItWasAllADream_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_lazagne:           ## Compiles Linux binary for AlessandroZ's LaZagne.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_lazagne.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne.zip $(LAZAGNE_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lazagne_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_lsassy:            ## Compiles Linux binary for Hackndo's lsassy.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_lsassy.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy.zip $(LSASSY_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/lsassy_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_nopac:             ## Compiles Linux binary for Ridter's noPac.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_nopac.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac.zip $(NOPAC_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/noPac_* $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_pachine:           ## Compiles Linux binary for ly4k's Pachine.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_pachine.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine.zip $(PACHINE_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Pachine; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pachine_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_printnightmare:    ## Compiles Linux binary for cube0x0's CVE-2021-1675. 
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_printnightmare.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675.zip $(PRINTNIGHTMARE_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2021-1675_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_pypykatz:          ## Compiles Linux binary for skelsec's pypykatz.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_pypykatz.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz.zip $(PYPYKATZ_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pypykatz_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_pywhisker:         ## Compiles Linux binary for Shutdown's pywhisker.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_pywhisker.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker.zip $(PYWHISKER_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/pywhisker_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_responder:         ## Compiles Linux binaries for Responder.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_responder.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder.zip $(RESPONDER_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/Responder/
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/Responder/
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/MultiRelay_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/Responder/
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/Responder.conf $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/Responder/

linux_smartbrute:        ## Compiles Linux binaries for Shutdown's smartbrute.
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_smartbrute.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute.zip $(SMARTBRUTE_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute-main $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smartbrute_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_smbmap:            ## Compiles Linux binary for ShawnDEvans' smbmap.
	mkdir -p $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_smbmap.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap.zip $(SMBMAP_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/smbmap_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

linux_zerologon:         ## Compiles Linux binaries for dirkjanm's CVE-2020-1472.
	@$(MAKE) -f $(THIS_FILE) _impacket_download
	cp $(PROJECT_PATH_LINUX)/build_scripts/build_linux_zerologon.sh $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	chmod +x $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/$(DOCKER_LINUX_ENTRYPOINT_FILE)
	if [ ! -f "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472.zip" ]; then wget -O $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472.zip $(ZEROLOGON_URL); fi
	if [ ! -d "$(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472" ]; then unzip -q $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472.zip -d $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER) && mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472-master $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/CVE-2020-1472; fi
	@$(MAKE) -f $(THIS_FILE) _docker_linux_run
	mkdir -p $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/cve-2020-1472-exploit_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/
	mv -f $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)/restorepassword_linux $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER)/

clean:                   ## Clean build artefacts by deleting the build folder.
	rm -rf $(PROJECT_PATH_LINUX)/$(BUILD_FOLDER)

test:                    ## Executes all the Windows / Linux binaries (for a manual review of errors use make test 1>/dev/null).
	echo "Executing all Windows binaries"
	@powershell.exe -c 'Get-ChildItem -Recurse -Path "$(PROJECT_PATH_WINDOWS)\$(OUTPUT_FOLDER)\*.exe" | % { Write-Host $$_.FullName; & "$$_" }'
	echo "Executing all Linux binaries"
	cd $(PROJECT_PATH_LINUX)/$(OUTPUT_FOLDER) && find . \( -iname "*_linux" ! -iname "sniffer_linux" \) -exec echo {} \; -exec {} \;