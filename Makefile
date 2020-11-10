.PHONY: all windows help

help:	## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

all: windows ## (Build everything - windows for now)

windows: ## Build Windows_x64 binaries
	mkdir -p tmp_build
	chmod +x build_windows.sh
	cp build_windows.sh tmp_build/
	chmod +x tmp_build/build_windows.sh
	git clone https://github.com/dirkjanm/CVE-2020-1472 tmp_build/CVE-2020-1472
	wget -P tmp_build https://github.com/SecureAuthCorp/impacket/archive/master.zip
	unzip tmp_build/master.zip -d tmp_build
	rm -f tmp_build/master.zip
	@docker run --rm -v "${PWD}/tmp_build:/zerologon" -w "/zerologon" --entrypoint="/zerologon/build_windows.sh" cdrx/pyinstaller-windows:latest

clean:  ## Remove all build artifacts
	rm -rf tmp_build
