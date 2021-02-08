# Set rights
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

# Set explorer settings
$explorerAdvancedSettingsPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

Set-ItemProperty -Path $explorerAdvancedSettingsPath -Name HideFileExt -Value 0
Set-ItemProperty -Path $explorerAdvancedSettingsPath -Name Hidden -Value 1

# Install winget
$localFile = "./winget.appxbundle"

Start-BitsTransfer -Source https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -Destination $localFile

Add-AppxPackage -Path $localFile

Remove-Item -Path $localFile

# Install other software
$applications = "Google.Chrome", "Microsoft.VisualStudioCode-User-x64", "Microsoft.WindowsTerminal", "Microsoft.PowerShell", "Docker.DockerDesktop", "SlackTechnologies.Slack", "Microsoft.Teams"

foreach($application in $applications) {
    winget install --id $application --exact --silent
}

# Restart
Restart-Computer -Confirm