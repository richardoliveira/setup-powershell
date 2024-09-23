Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force
winget install JanDeDobbeleer.OhMyPosh -s winget
Add-Content -Path $PROFILE -Value "`noh-my-posh init pwsh | Invoke-Expression"
Write-Host "Oh My Posh foi instalado e configurado. Por favor, reinicie o PowerShell para aplicar as mudanças."
