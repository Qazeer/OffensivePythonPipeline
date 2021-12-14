# Validate that the script is executed from within a Docker container.
If ($null -eq $(Get-Service -Name cexecsvc -ErrorAction SilentlyContinue)) {
    Write-Host "The script should be run inside a Docker container!"
    Exit 1
}

# Install Python (if isn't already installed).
If (!(Test-Path -Path C:\Python_last\python.exe)) {
    Write-Host "Installing Python..."
    Start-Process C:\host_build\python_last.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1 TargetDir="C:\Python_last' -Wait
}

# Install PyInstaller (if isn't already installed).
If (!(C:\Python_last\python.exe -m pip list | Select-String -Quiet -Pattern "pyinstaller")) {
    Write-Host "Installing PyInstaller..."
    C:\Python_last\python.exe -m pip install pyinstaller==4.3
}

# Install impacket (if isn't already installed).
If (!(C:\Python_last\python.exe -m pip list | Select-String -Quiet -Pattern "impacket")) {
    Set-Location C:\host_build\impacket-SecureAuthCorp
    C:\Python_last\python.exe -m pip install .
    C:\Python_last\python.exe setup.py egg_info
}

# Certipy does not specify a requirements file, creating one using setup.py egg_info.
Set-Location C:\host_build\Certipy\
C:\Python_last\python.exe setup.py egg_info
C:\Python_last\python.exe -m pip install -r C:\host_build\Certipy\Certipy.egg-info\requires.txt

# Create standalone binaries.
C:\Python_last\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\host_build\Certipy\certipy\entry.py

# Export the compiled binaries.
Move-Item -Force $env:temp\out\entry.exe C:\host_build\certipy_windows.exe