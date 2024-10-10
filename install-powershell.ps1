Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

if (!(Test-Path -Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }

"noh-my-posh init pwsh | Invoke-Expression" | Out-File -FilePath $PROFILE -Append

winget install JanDeDobbeleer.OhMyPosh -s winget

function Install-Font {
    param (
        [string]$url,
        [string]$fontName
    )

    $fontZipPath = "$env:TEMP\$fontName.zip"
    Invoke-WebRequest -Uri $url -OutFile $fontZipPath

    # Extrair o arquivo zip
    $extractPath = "$env:TEMP\$fontName"
    Expand-Archive -Path $fontZipPath -DestinationPath $extractPath -Force

    # Instalar as fontes
    Get-ChildItem "$extractPath\*.ttf" | ForEach-Object {
        $fontFile = $_.FullName
        $fontInstaller = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
        Start-Process -FilePath $fontInstaller -ArgumentList "Add-Type -AssemblyName System.Drawing; [System.Drawing.Text.PrivateFontCollection]::new().AddFontFile('$fontFile')"
    }

    # Limpar arquivos temporários
    Remove-Item -Path $fontZipPath
    Remove-Item -Path $extractPath -Recurse -Force
}

$fonts = @{
    "Meslo" = "https://github.com/andreberg/Meslo-Font/raw/refs/heads/master/dist/v1.2.1/Meslo%20LG%20v1.2.1.zip";
    "Fira Code" = "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip";
    "Inter" = "https://github.com/rsms/inter/releases/download/v3.19/Inter-3.19.zip";
    "JetBrains Mono" = "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
}

foreach ($font in $fonts.GetEnumerator()) {
    Install-Font -url $font.Value -fontName $font.Key
}

Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Write-Host "Oh My Posh e as fontes foram instalados e configurados. Por favor, reinicie o PowerShell para aplicar as mudanças."
