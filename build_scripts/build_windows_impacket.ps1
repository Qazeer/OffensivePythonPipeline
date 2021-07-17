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

# Install impacket (update if it is already installed to make sure the version is compatible with the examples).
Set-Location C:\host_build\impacket-SecureAuthCorp
C:\Python\python.exe -m pip install .
C:\Python\python.exe setup.py install

C:\Python\python.exe -m pip install pyreadline

# Create standalone binaries.
Get-ChildItem "C:\host_build\impacket-SecureAuthCorp\examples" -Filter *.py | 
Foreach-Object {
    C:\Python\python.exe -m PyInstaller --hidden-import=impacket.examples.utils --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F $_.FullName
}

# Export the compiled binaries.
New-Item -Force -Path "C:\host_build\" -Name "impacket" -ItemType "directory"
Get-ChildItem "$env:temp\out" -Filter *.exe | 
Foreach-Object {
    Move-Item -Force $_.FullName "C:\host_build\impacket\$($_.Name.Split('.')[0])_windows.exe"
}