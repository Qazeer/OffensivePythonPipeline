# Validate that the script is executed from within a Docker container.
If ($null -eq $(Get-Service -Name cexecsvc -ErrorAction SilentlyContinue)) {
    Write-Host "The script should be run inside a Docker container!"
    Exit 1
}

# Install Microsoft Visual C++ (if isn't already installed).
If (!(Test-Path -Path C:\Windows\System32\msvcp100.dll)) {
    Write-Host "Installing Microsoft Visual x64 C++..."
    Start-Process C:\host_build\VC_redist.x64.exe -ArgumentList '/install /quiet' -Wait
    Write-Host "Installing Microsoft Visual x86 C++..."
    Start-Process C:\host_build\VC_redist.x86.exe -ArgumentList '/install /quiet' -Wait
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

# Install Lazagne requirements.
Copy-Item -Recurse -Path C:\host_build\lazagne -Destination C:\lazagne
Set-Location C:\lazagne
C:\Python\python.exe -m pip install -r .\requirements.txt

Set-Location C:\lazagne\Windows
C:\Python\python.exe -m PyInstaller --onefile --clean -F lazagne.spec

# Export the compiled binary.
Move-Item -Force C:\lazagne\Windows\dist\lazagne.exe C:\host_build\lazagne_windows.exe
