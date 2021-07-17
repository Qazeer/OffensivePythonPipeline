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

# Manually install pywerview to remove the pycrypto dependency.
# May become unnecessary if issue https://github.com/the-useless-one/pywerview/issues/44 is fixed.
Copy-Item -Recurse -Path C:\host_build\pywerview -Destination C:\pywerview
Set-Location C:\pywerview
Get-Content setup.py | Select-String -NotMatch -Pattern 'pycrypto' | ForEach-Object { $_.Line } | Out-File -Encoding Default setup-updated.py
C:\Python\python.exe -m pip install -r .\requirements.txt
C:\Python\python.exe .\setup-updated.py install

# Install CrackMapExec requirements after removing the pycrypto dependency.
Copy-Item -Recurse -Path C:\host_build\CrackMapExec -Destination C:\CrackMapExec
Set-Location C:\CrackMapExec
Get-Content requirements.txt | Select-String -Encoding Default -NotMatch -Pattern 'pycrypto==2.6.1', 'pywerview==0.3.0' | ForEach-Object { $_.Line } | Out-File -Encoding Default requirements-updated.txt
C:\Python\python.exe -m pip install -r .\requirements-updated.txt

# Creates PyInstaller hooks for lsassy.
New-Item -Force -ItemType "directory" -Path C:\CrackMapExec\hooks
Write-Output  '# -*- coding:utf-8 -*-

from PyInstaller.utils.hooks import collect_all

datas, binaries, hiddenimports = collect_all("lsassy")' | Out-File -NoNewline -Force -Encoding Default -FilePath C:\CrackMapExec\hooks\hook-lsassy.py

# Build the standalone crackmapexec binary after adding the hidden import for impacket.ldap.
# May become unnecessary if issue https://github.com/byt3bl33d3r/CrackMapExec/issues/475 is fixed.
(Get-Content crackmapexec.spec -Raw) -Replace "'impacket.tds'","'impacket.ldap.ldap', 'impacket.tds'" | Out-File -NoNewline -Encoding Default crackmapexec-updated.spec
(Get-Content crackmapexec-updated.spec -Raw) -Replace "hookspath=\[]","hookspath=['hooks']" | Out-File -NoNewline -Encoding Default crackmapexec-updated.spec

C:\Python\python.exe -m PyInstaller --onefile --clean -F crackmapexec-updated.spec

# Export the compiled binary.
Move-Item -Force C:\CrackMapExec\dist\crackmapexec.exe C:\host_build\crackmapexec_windows.exe
