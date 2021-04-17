# Author: Devilly
# Summary: installation of authors development environment
# Details: needs to be executed with Windows PowerShell as administrator

Param($deviceType)

# Show all icons in the notification area
$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"

Set-ItemProperty -Path $path -Name EnableAutoTray -Value 0

# Set advanced explorer settings...
$path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

# ...show file extensions
Set-ItemProperty -Path $path -Name HideFileExt -Value 0
# ...show hidden files
Set-ItemProperty -Path $path -Name Hidden -Value 1

# Set some Windows locale settings
Set-WinSystemLocale -SystemLocale en-US
Set-TimeZone -Id "W. Europe Standard Time"

$inputTipUnitedStatesInternational = "0409:00020409"

$languageList = New-WinUserLanguageList -Language en-US
$languageList[0].Spellchecking = $false
$languageList[0].InputMethodTips.Clear()
$languageList[0].InputMethodTips.Add($inputTipUnitedStatesInternational)
Set-WinUserLanguageList -LanguageList $languageList -Force

# Make sure US International is always the preferred input method
# Can prevent unwanted behaviour when adding other languages, e.g.
Set-WinDefaultInputMethodOverride -InputTip $inputTipUnitedStatesInternational

# Install winget
$path = Join-Path -Path . -ChildPath winget.appxbundle

Start-BitsTransfer -Source https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -Destination $path

Add-AppxPackage -Path $path

Remove-Item -Path $path

# Install applications
$applications = @(
    "Google.Chrome"
    "Microsoft.VisualStudioCode.User-x64"
    "Microsoft.WindowsTerminal"
    "Microsoft.PowerToys"
    "Microsoft.PowerShell"
)

if($deviceType -contains "hobby") {
    $applications += $(
        "Microsoft.dotnet"
        "KDE.Krita"
    )
}

if($deviceType -contains "work") {
    $applications += $(
        "Docker.DockerDesktop"
        "SlackTechnologies.Slack"
        "Microsoft.Teams"
    )
}

foreach($application in $applications) {
    winget install --id $application --exact --silent
}

# Install VolumeCtrl
$path = Join-Path -Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::Startup)) -ChildPath VolumeCtrl.exe
Start-BitsTransfer -Source https://github.com/Devilly/VolumeCtrl/releases/latest/download/VolumeCtrl.exe -Destination $path

# Restart
Restart-Computer -Confirm
