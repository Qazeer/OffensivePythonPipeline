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

# Install pypykatz requirements.
Copy-Item -Recurse -Path C:\host_build\pypykatz -Destination C:\pypykatz
Set-Location C:\pypykatz
C:\Python\python.exe -m pip install --upgrade --no-cache-dir minidump minikerberos aiowinreg aiosmb msldap winacl
C:\Python\python.exe setup.py install

# Create standalone the binary.
C:\Python\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\pypykatz\pypykatz\__amain__.py

# Export the compiled binary.
Move-Item -Force $env:temp\out\__amain__.exe C:\host_build\pypykatz_windows.exe
