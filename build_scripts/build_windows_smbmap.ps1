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

# Install dependencies.
Copy-Item -Recurse -Path C:\host_build\smbmap -Destination C:\smbmap
Set-Location C:\smbmap
(Get-Content requirements.txt -Raw) -Replace "https://github.com/CoreSecurity/impacket/archive/impacket_0_9_21.zip","impacket" | Out-File -Encoding Default requirements-updated.txt
(Get-Content requirements-updated.txt -Raw) -Replace "pycrypto","pycryptodome" | Out-File -Encoding Default requirements-updated.txt
C:\Python\python.exe -m pip install pycryptodome
C:\Python\python.exe -m pip install -r .\requirements-updated.txt

Write-Output  '# -*- coding:utf-8 -*-

from PyInstaller.utils.hooks import copy_metadata

datas = copy_metadata("impacket")' > ./hook-impacket.py

# Create the standalone binary.
C:\Python\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --onefile --clean -F C:\smbmap\smbmap.py

# Export the compiled binary.
Move-Item -Force $env:temp\out\smbmap.exe C:\host_build\smbmap_windows.exe
