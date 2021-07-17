Write-Host "Not functional!"
Exit 1

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

# Install Responder / MultiRelay dependencies.
C:\Python\python.exe -m pip install pycryptodome

# Removes the Linux dependant check for root (os.geteuid() == 0) and updates the directory in which Responder loads its Responder.conf file.
Copy-Item -Recurse -Path C:\host_build\Responder -Destination C:\Responder
Set-Location C:\Responder
(Get-Content Responder.py -Raw) -Replace "os.geteuid\(\) == 0","True" | Out-File -Force -Encoding Default Responder.py
(Get-Content settings.py -Raw) -Replace "os.path.dirname\(__file__\)","'.'" | Out-File -Force -Encoding Default settings.py

# Create standalone binaries.
C:\Python\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\Responder\Responder.py
C:\Python\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\Responder\tools\MultiRelay.py

# Export the compiled binaries and Responder default configuration file.
Move-Item -Force $env:temp\out\Responder.exe C:\host_build\Responder_windows.exe
Move-Item -Force $env:temp\out\MultiRelay.exe C:\host_build\MultiRelay_windows.exe
Copy-Item -Force C:\Responder\Responder.conf C:\host_build\Responder.conf