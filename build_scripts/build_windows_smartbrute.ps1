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
    C:\Python\python.exe -m pip install pyinstaller==4.4
}

# Install impacket (if isn't already installed).
If (!(C:\Python\python.exe -m pip list | Select-String -Quiet -Pattern "impacket")) {
    Set-Location C:\host_build\impacket-SecureAuthCorp
    C:\Python\python.exe -m pip install .
    C:\Python\python.exe setup.py egg_info
}

# Install requirements.
Copy-Item -Recurse -Path C:\host_build\smartbrute -Destination C:\smartbrute
Set-Location C:\smartbrute
C:\Python\python.exe -m pip install -r requirements.txt

# Fix exit by importing sys.
(Get-Content C:\smartbrute\smartbrute.py) -Replace "import os","import os`nfrom sys import exit`n" | Set-Content C:\smartbrute\smartbrute.py

# Create standalone binaries.
C:\Python\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\smartbrute\smartbrute.py

# Export the compiled binaries.
Move-Item -Force $env:temp\out\smartbrute.exe C:\host_build\smartbrute_windows.exe