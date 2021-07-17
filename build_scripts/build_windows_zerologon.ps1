# Validate that the script is executed from within a Docker container.
If ($null -eq $(Get-Service -Name cexecsvc -ErrorAction SilentlyContinue)) {
    Write-Host "The script should be run inside a Docker container!"
    Exit 1
}

# Install Python (if isn't already installed).
If (!(Test-Path -Path C:\Python\python.exe)) {
    Write-Host "Installing Python..."
    Start-Process C:\host_build\python.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1 TargetDir="C:\Python' -Wait
}

# Install PyInstaller (if isn't already installed).
If (!(C:\Python\python.exe -m pip list | Select-String -Quiet -Pattern "pyinstaller")) {
    Write-Host "Installing PyInstaller..."
    C:\Python\python.exe -m pip install pyinstaller==4.3
}

# Install impacket (if isn't already installed).
If (!(C:\Python\python.exe -m pip list | Select-String -Quiet -Pattern "impacket")) {
    Set-Location C:\host_build\impacket-SecureAuthCorp
    C:\Python\python.exe -m pip install .
    C:\Python\python.exe setup.py egg_info
}

# Create standalone binaries.
C:\Python\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\host_build\CVE-2020-1472\cve-2020-1472-exploit.py
C:\Python\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\host_build\CVE-2020-1472\restorepassword.py

# Export the compiled binaries.
Move-Item -Force $env:temp\out\cve-2020-1472-exploit.exe C:\host_build\cve-2020-1472-exploit_windows.exe
Move-Item -Force $env:temp\out\restorepassword.exe C:\host_build\restorepassword_windows.exe