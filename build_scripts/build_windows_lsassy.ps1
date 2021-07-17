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

# Install lsassy requirements.
Copy-Item -Recurse -Path C:\host_build\lsassy -Destination C:\lsassy
Set-Location C:\lsassy
C:\Python\python.exe -m pip install -r .\requirements.txt
C:\Python\python.exe -m pip install lsassy

# Creates PyInstaller hooks for lsassy.
New-Item -Force -ItemType "directory" -Path C:\lsassy\hooks
Write-Output  '# -*- coding:utf-8 -*-

from PyInstaller.utils.hooks import collect_all

datas, binaries, hiddenimports = collect_all("lsassy")' | Out-File -Force -Encoding Default -FilePath C:\lsassy\hooks\hook-lsassy.py

C:\Python\python.exe -m PyInstaller --additional-hooks-dir=C:\lsassy\hooks --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\lsassy\lsassy\core.py

# Export the compiled binary.
Move-Item -Force $env:temp\out\core.exe C:\host_build\lsassy_windows.exe
