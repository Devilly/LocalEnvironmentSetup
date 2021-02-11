# Loosen PowerShell execution policy
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

# Set explorer settings
$path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

Set-ItemProperty -Path $path -Name HideFileExt -Value 0
Set-ItemProperty -Path $path -Name Hidden -Value 1

# Install winget
$path = Join-Path . winget.appxbundle

Start-BitsTransfer -Source https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -Destination $path

Add-AppxPackage -Path $path

Remove-Item -Path $path

# Install other software
$applications = "Google.Chrome", "Microsoft.VisualStudioCode-User-x64", "Microsoft.WindowsTerminal", "Microsoft.PowerShell", "Docker.DockerDesktop", "SlackTechnologies.Slack", "Microsoft.Teams"

foreach($application in $applications) {
    winget install --id $application --exact --silent
}

# Install VolumeCtrl
$path = Join-Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::Startup)) VolumeCtrl.exe
Start-BitsTransfer -Source https://github.com/Devilly/VolumeCtrl/releases/latest/download/VolumeCtrl.exe -Destination $path

# Restart
Restart-Computer -Confirm