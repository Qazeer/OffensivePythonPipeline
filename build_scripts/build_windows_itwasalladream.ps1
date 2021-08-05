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

# Force install of the last impacket version (to make sure the version used has the necessary MS-PAR implementation ).
If ((C:\Python\python.exe -m pip list | Select-String -Quiet -Pattern "impacket")) {
    C:\Python\python.exe -m pip uninstall impacket
}
Set-Location C:\host_build\impacket-SecureAuthCorp
C:\Python\python.exe -m pip install .
C:\Python\python.exe setup.py egg_info

Copy-Item -Recurse -Path C:\host_build\ItWasAllADream -Destination C:\ItWasAllADream
Set-Location C:\ItWasAllADream
C:\Python\python.exe -m pip install -r requirements.txt
# Call main() as ItWasAllADream does not define "if __name__ == "__main__"
Add-Content C:\ItWasAllADream\itwasalladream\__main__.py "`n`nmain()"

# Create standalone the binary.
C:\Python\python.exe -m PyInstaller --specpath $env:temp\spec --workpath $env:temp\build --distpath $env:temp\out --clean -F C:\ItWasAllADream\itwasalladream\__main__.py

# Export the compiled binary.
Move-Item -Force $env:temp\out\__main__.exe C:\host_build\ItWasAllADream_windows.exe