# Definir política de execução
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Instalar Chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Habilitar recursos do Windows
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Configurar Oh My Posh
if (!(Test-Path -Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }
"oh-my-posh init pwsh | Invoke-Expression" | Out-File -FilePath $PROFILE -Append

# Instalar Git e Oh My Posh
winget install --id Git.Git -e --source winget
winget install JanDeDobbeleer.OhMyPosh -s winget

# Função para instalar fontes
function Install-Font {
    param (
        [string]$url,
        [string]$fontName
    )
    $fontZipPath = "$env:TEMP\$fontName.zip"
    $extractPath = "$env:TEMP\$fontName"
    
    # Baixar e extrair o arquivo zip
    Invoke-WebRequest -Uri $url -OutFile $fontZipPath
    Expand-Archive -Path $fontZipPath -DestinationPath $extractPath -Force

    # Instalar as fontes
    $FONTS = 0x14
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace($FONTS)

    $fontsInstalled = @()
    
    foreach ($font in (Get-ChildItem "$extractPath\*.ttf")) {
        $objFolder.CopyHere($font.FullName, 0x10)
        $fontsInstalled += $font.Name
    }

    # Limpar arquivos temporários
    Remove-Item -Path $fontZipPath -Force
    Remove-Item -Path $extractPath -Recurse -Force

    return $fontsInstalled
}

# Lista de fontes para instalar
$fonts = @{
    "Meslo" = "https://github.com/andreberg/Meslo-Font/raw/refs/heads/master/dist/v1.2.1/Meslo%20LG%20v1.2.1.zip";
    "Fira Code" = "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip";
    "Inter" = "https://github.com/rsms/inter/releases/download/v3.19/Inter-3.19.zip";
    "JetBrains Mono" = "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
}

# Instalar fontes
$installedFonts = @()
foreach ($font in $fonts.GetEnumerator()) {
    $installedFonts += Install-Font -url $font.Value -fontName $font.Key
}

# Instalar WSL
wsl --install

# Informar ao usuário sobre as ações realizadas e próximos passos
Write-Host "As seguintes ações foram realizadas:"
Write-Host "1. Chocolatey foi instalado"
Write-Host "2. Recursos do Windows (WSL e VirtualMachinePlatform) foram habilitados"
Write-Host "3. Oh My Posh foi configurado"
Write-Host "4. Git e Oh My Posh foram instalados"
Write-Host "5. As seguintes fontes foram instaladas: $($installedFonts -join ', ')"
Write-Host "6. WSL foi instalado"

Write-Host "`nPróximos passos:"
Write-Host "1. Reinicie o seu computador para aplicar todas as mudanças"
Write-Host "2. Após reiniciar, abra um novo PowerShell para ver as mudanças do Oh My Posh"
Write-Host "3. Se você quiser usar as novas fontes no seu terminal, você precisará configurá-las manualmente nas configurações do seu terminal"

# Perguntar ao usuário se deseja reiniciar agora
$restart = Read-Host "Deseja reiniciar o computador agora? (S/N)"
if ($restart -eq "S" -or $restart -eq "s") {
    Restart-Computer -Force
}
