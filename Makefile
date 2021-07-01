.PHONY: help all windows windows_zerologon windows_printnightmare linux linux_zerologon linux_printnightmare clean

help:                    ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

all:                     ## Compiles all binaries for both Windows and Linux.
all: windows linux 

windows:                 ## Compiles all Windows binaries.
windows: windows_zerologon windows_printnightmare

windows_zerologon:       ## Compiles Windows binaries for dirkjanm's CVE-2020-1472.
	mkdir -p tmp_build
	cp build_scripts/build_windows_zerologon.sh tmp_build/
	chmod +x tmp_build/build_windows_zerologon.sh
	if [ ! -d "tmp_build/CVE-2020-1472" ]; then git clone https://github.com/dirkjanm/CVE-2020-1472 tmp_build/CVE-2020-1472; fi
	if [ ! -f "tmp_build/impacket-SecureAuthCorp.zip" ]; then wget -O tmp_build/impacket-SecureAuthCorp.zip https://github.com/SecureAuthCorp/impacket/archive/master.zip; fi
	if [ ! -d "tmp_build/impacket-SecureAuthCorp" ]; then unzip tmp_build/impacket-SecureAuthCorp.zip -d tmp_build && mv tmp_build/impacket-master tmp_build/impacket-SecureAuthCorp; fi
	@docker run --rm -v "${PWD}/tmp_build:/zerologon" -w "/zerologon" --entrypoint="/zerologon/build_windows_zerologon.sh" cdrx/pyinstaller-windows:latest
	mkdir -p binaries
	mv tmp_build/cve-2020-1472-exploit_windows.exe binaries/
	mv tmp_build/restorepassword_windows.exe binaries/

windows_printnightmare:  ## Compiles Windows binary for cube0x0's CVE-2021-1675.  
	mkdir -p tmp_build
	cp build_scripts/build_windows_printnightmare.sh tmp_build/
	chmod +x tmp_build/build_windows_printnightmare.sh
	if [ ! -d "tmp_build/CVE-2021-1675" ]; then git clone https://github.com/cube0x0/CVE-2021-1675 tmp_build/CVE-2021-1675; fi
	if [ ! -f "tmp_build/impacket-cube0x0.zip" ]; then wget -O tmp_build/impacket-cube0x0.zip https://github.com/cube0x0/impacket/archive/refs/heads/master.zip; fi
	if [ ! -d "tmp_build/impacket-cube0x0" ]; then unzip tmp_build/impacket-cube0x0.zip -d tmp_build && mv tmp_build/impacket-master tmp_build/impacket-cube0x0; fi
	@docker run --rm -v "${PWD}/tmp_build:/printnightmare" -w "/printnightmare" --entrypoint="/printnightmare/build_windows_printnightmare.sh" cdrx/pyinstaller-windows:latest
	mkdir -p binaries
	mv tmp_build/CVE-2021-1675_windows.exe binaries/

linux:                   ## Compiles all Linux binaries.
linux: linux_zerologon linux_printnightmare

linux_zerologon:         ## Compiles Linux binaries for dirkjanm's CVE-2020-1472.
	mkdir -p tmp_build
	cp build_scripts/build_linux_zerologon.sh tmp_build/
	chmod +x tmp_build/build_linux_zerologon.sh
	if [ ! -d "tmp_build/CVE-2020-1472" ]; then git clone https://github.com/dirkjanm/CVE-2020-1472 tmp_build/CVE-2020-1472; fi
	if [ ! -f "tmp_build/impacket-SecureAuthCorp.zip" ]; then wget -O tmp_build/impacket-SecureAuthCorp.zip https://github.com/SecureAuthCorp/impacket/archive/master.zip; fi
	if [ ! -d "tmp_build/impacket-SecureAuthCorp" ]; then unzip tmp_build/impacket-SecureAuthCorp.zip -d tmp_build && mv tmp_build/impacket-master tmp_build/impacket-SecureAuthCorp; fi
	@docker run --rm -v "${PWD}/tmp_build:/zerologon" -w "/zerologon" cdrx/pyinstaller-linux:latest /zerologon/build_linux_zerologon.sh
	mkdir -p binaries
	mv tmp_build/cve-2020-1472-exploit_linux binaries/
	mv tmp_build/restorepassword_linux binaries/

linux_printnightmare:    ## Compiles Linux binary for cube0x0's CVE-2021-1675. 
	mkdir -p tmp_build
	cp build_scripts/build_linux_printnightmare.sh tmp_build/
	chmod +x tmp_build/build_linux_printnightmare.sh
	if [ ! -d "tmp_build/CVE-2021-1675" ]; then git clone https://github.com/cube0x0/CVE-2021-1675 tmp_build/CVE-2021-1675; fi
	if [ ! -f "tmp_build/impacket-cube0x0.zip" ]; then wget -O tmp_build/impacket-cube0x0.zip https://github.com/cube0x0/impacket/archive/refs/heads/master.zip; fi
	if [ ! -d "tmp_build/impacket-cube0x0" ]; then unzip tmp_build/impacket-cube0x0.zip -d tmp_build && mv tmp_build/impacket-master tmp_build/impacket-cube0x0; fi
	@docker run --rm -v "${PWD}/tmp_build:/printnightmare" -w "/printnightmare" cdrx/pyinstaller-linux:latest /printnightmare/build_linux_printnightmare.sh
	mkdir -p binaries
	mv tmp_build/CVE-2021-1675_linux binaries/

clean:                   # Clean build artefacts.
	rm -rf tmp_build
