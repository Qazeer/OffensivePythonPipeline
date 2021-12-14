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

# gMSADumper does not specify a requirements file. TODO: get pipreqs to work properly.
Set-Location C:\host_build\gMSADumper\
C:\Python\python.exe -m pip freeze C:\host_build\gMSADumper\gMSADumper.py > C:\host_build\gMSADumper\requirements.txt
C:\Python\python.exe -m pip install -r C:\host_build\gMSADumper\requirements.txt

# Create standalone binaries.
C:\Python\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\host_build\gMSADumper\gMSADumper.py

# Export the compiled binaries.
Move-Item -Force $env:temp\out\gMSADumper.exe C:\host_build\gMSADumper_windows.exe
