.PHONY: all windows linux clean help

help: ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

all: windows linux ## (Build everything)

windows: ## Build Windows_x64 binaries
	mkdir -p tmp_build
	cp build_scripts/build_windows.sh tmp_build/
	chmod +x tmp_build/build_windows.sh
	if [ ! -d "tmp_build/CVE-2020-1472" ]; then git clone https://github.com/dirkjanm/CVE-2020-1472 tmp_build/CVE-2020-1472; fi
	if [ ! -f "tmp_build/master.zip" ]; then wget -P tmp_build https://github.com/SecureAuthCorp/impacket/archive/master.zip; fi
	if [ ! -d "tmp_build/impacket-master" ]; then unzip tmp_build/master.zip -d tmp_build; fi
	@docker run --rm -v "${PWD}/tmp_build:/zerologon" -w "/zerologon" --entrypoint="/zerologon/build_windows.sh" cdrx/pyinstaller-windows:latest

linux: ## Build Linux_x64 binaries
	mkdir -p tmp_build
	cp build_scripts/build_linux.sh tmp_build/
	chmod +x tmp_build/build_linux.sh
	if [ ! -d "tmp_build/CVE-2020-1472" ]; then git clone https://github.com/dirkjanm/CVE-2020-1472 tmp_build/CVE-2020-1472; fi
	if [ ! -f "tmp_build/master.zip" ]; then wget -P tmp_build https://github.com/SecureAuthCorp/impacket/archive/master.zip; fi
	if [ ! -d "tmp_build/impacket-master" ]; then unzip tmp_build/master.zip -d tmp_build; fi
	@docker run --rm -v "${PWD}/tmp_build:/zerologon" -w "/zerologon" cdrx/pyinstaller-linux:latest /zerologon/build_linux.sh

clean: ## Remove all build artifacts
	rm -rf tmp_build
