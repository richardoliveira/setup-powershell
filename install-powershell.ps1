Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force
winget install JanDeDobbeleer.OhMyPosh -s winget

if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

Add-Content -Path $PROFILE -Value "`noh-my-posh init pwsh | Invoke-Expression"

function Install-Font {
    param (
        [string]$url,
        [string]$fontName
    )
    $fontPath = "$env:TEMP\$fontName"
    Invoke-WebRequest -Uri $url -OutFile $fontPath
    Start-Process $fontPath -ArgumentList '/VERYSILENT' -Wait
    Remove-Item $fontPath
}

$fonts = @{
    "Meslo" = "https://github.com/andreberg/Meslo-Font/blob/master/dist/v1.2/MesloLGS%20NF%20Regular.ttf?raw=true";
    "Fira Code" = "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip";
    "Inter" = "https://github.com/rsms/inter/releases/download/v3.19/Inter-3.19.zip";
    "JetBrains Mono" = "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
}

foreach ($font in $fonts.GetEnumerator()) {
    Install-Font -url $font.Value -fontName "$($font.Key).exe"
}

Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Write-Host "Oh My Posh e as fontes foram instalados e configurados. Por favor, reinicie o PowerShell para aplicar as mudanças."
