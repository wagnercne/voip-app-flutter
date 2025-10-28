# Script de Configuração do Android SDK para Flutter
# Execute este script como Administrador após instalar o Android Studio

Write-Host "🚀 Configurando Android SDK para Flutter..." -ForegroundColor Green

# Caminhos padrão do Android SDK
$androidSdkPath = "$env:LOCALAPPDATA\Android\Sdk"
$androidStudioPath = "$env:ProgramFiles\Android\Android Studio"

# Verifica se o Android SDK existe
if (Test-Path $androidSdkPath) {
    Write-Host "✅ Android SDK encontrado em: $androidSdkPath" -ForegroundColor Green
    
    # Configura variáveis de ambiente do sistema
    Write-Host "📝 Configurando variáveis de ambiente..." -ForegroundColor Yellow
    
    # ANDROID_HOME
    [Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidSdkPath, "User")
    [Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $androidSdkPath, "User")
    
    # Adiciona ao PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    $platformTools = "$androidSdkPath\platform-tools"
    $tools = "$androidSdkPath\tools"
    $toolsBin = "$androidSdkPath\tools\bin"
    $emulator = "$androidSdkPath\emulator"
    
    if ($currentPath -notlike "*$platformTools*") {
        $newPath = "$currentPath;$platformTools;$tools;$toolsBin;$emulator"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Host "✅ Adicionado ao PATH: platform-tools, tools, emulator" -ForegroundColor Green
    }
    
    # Atualiza variáveis na sessão atual
    $env:ANDROID_HOME = $androidSdkPath
    $env:ANDROID_SDK_ROOT = $androidSdkPath
    $env:PATH = "$env:PATH;$platformTools;$tools;$toolsBin;$emulator"
    
    Write-Host "✅ Variáveis de ambiente configuradas!" -ForegroundColor Green
    Write-Host "ANDROID_HOME: $androidSdkPath" -ForegroundColor Cyan
    Write-Host "PATH atualizado com platform-tools" -ForegroundColor Cyan
    
} else {
    Write-Host "❌ Android SDK não encontrado em: $androidSdkPath" -ForegroundColor Red
    Write-Host "📋 Passos para instalação:" -ForegroundColor Yellow
    Write-Host "1. Baixe Android Studio de: https://developer.android.com/studio" -ForegroundColor White
    Write-Host "2. Execute o instalador" -ForegroundColor White
    Write-Host "3. Na primeira execução, siga o Setup Wizard" -ForegroundColor White
    Write-Host "4. Aceite as licenças do Android SDK" -ForegroundColor White
    Write-Host "5. Execute este script novamente" -ForegroundColor White
}

# Verifica se o Flutter pode detectar o Android SDK
Write-Host "🔍 Verificando configuração do Flutter..." -ForegroundColor Yellow
flutter doctor --android-licenses

Write-Host "🎯 Execute 'flutter doctor' para verificar a configuração" -ForegroundColor Green