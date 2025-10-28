# 🏷️ Script de Versionamento - VoIP Flutter App

# Este script automatiza o processo de versionamento do projeto

param(
    [Parameter(Mandatory=$true)]
    [string]$VersionType,
    
    [Parameter(Mandatory=$false)]
    [string]$Message = ""
)

# Tipos de versão: major, minor, patch
$validTypes = @("major", "minor", "patch")

if ($VersionType -notin $validTypes) {
    Write-Host "❌ Tipo de versão inválido. Use: major, minor, ou patch" -ForegroundColor Red
    Write-Host "Exemplo: .\versioning.ps1 -VersionType minor -Message 'Nova funcionalidade X'" -ForegroundColor Yellow
    exit 1
}

Write-Host "🚀 Iniciando versionamento: $VersionType" -ForegroundColor Green

# Ler versão atual do pubspec.yaml
$pubspecPath = "pubspec.yaml"
$pubspecContent = Get-Content $pubspecPath -Raw

# Extrair versão atual (formato: x.y.z+build)
if ($pubspecContent -match "version: (\d+)\.(\d+)\.(\d+)\+(\d+)") {
    $currentMajor = [int]$Matches[1]
    $currentMinor = [int]$Matches[2]
    $currentPatch = [int]$Matches[3]
    $currentBuild = [int]$Matches[4]
    
    Write-Host "📋 Versão atual: $currentMajor.$currentMinor.$currentPatch+$currentBuild" -ForegroundColor Cyan
} else {
    Write-Host "❌ Não foi possível encontrar a versão no pubspec.yaml" -ForegroundColor Red
    exit 1
}

# Calcular nova versão
switch ($VersionType) {
    "major" {
        $newMajor = $currentMajor + 1
        $newMinor = 0
        $newPatch = 0
        $newBuild = 1
    }
    "minor" {
        $newMajor = $currentMajor
        $newMinor = $currentMinor + 1
        $newPatch = 0
        $newBuild = 1
    }
    "patch" {
        $newMajor = $currentMajor
        $newMinor = $currentMinor
        $newPatch = $currentPatch + 1
        $newBuild = 1
    }
}

$newVersion = "$newMajor.$newMinor.$newPatch+$newBuild"
Write-Host "🆕 Nova versão: $newVersion" -ForegroundColor Green

# Confirmar mudança
$confirmation = Read-Host "Continuar com a atualização? (y/N)"
if ($confirmation -ne "y" -and $confirmation -ne "Y") {
    Write-Host "❌ Versionamento cancelado pelo usuário" -ForegroundColor Yellow
    exit 0
}

# Atualizar pubspec.yaml
Write-Host "📝 Atualizando pubspec.yaml..." -ForegroundColor Yellow
$newPubspecContent = $pubspecContent -replace "version: \d+\.\d+\.\d+\+\d+", "version: $newVersion"
Set-Content $pubspecPath $newPubspecContent

# Atualizar CHANGELOG.md
Write-Host "📋 Atualizando CHANGELOG.md..." -ForegroundColor Yellow
$changelogPath = "CHANGELOG.md"
$currentDate = Get-Date -Format "yyyy-MM-dd"

$changelogHeader = @"
## [$newVersion] - $currentDate

### 🔄 $VersionType Update
- 📦 Versão atualizada: $currentMajor.$currentMinor.$currentPatch → $newVersion
"@

if ($Message) {
    $changelogHeader += "`n- 📝 $Message"
}

$changelogHeader += "`n`n---`n"

# Inserir no início do changelog após o cabeçalho
$changelogContent = Get-Content $changelogPath -Raw
$insertPosition = $changelogContent.IndexOf("## [1.0.0]")
if ($insertPosition -gt 0) {
    $beforeInsert = $changelogContent.Substring(0, $insertPosition)
    $afterInsert = $changelogContent.Substring($insertPosition)
    $newChangelogContent = $beforeInsert + $changelogHeader + $afterInsert
    Set-Content $changelogPath $newChangelogContent
}

# Fazer commit das mudanças
Write-Host "📦 Fazendo commit das mudanças..." -ForegroundColor Yellow
git add .

$commitMessage = "🏷️ Version $newVersion"
if ($Message) {
    $commitMessage += ": $Message"
}

git commit -m $commitMessage

# Criar tag
Write-Host "🏷️ Criando tag v$newVersion..." -ForegroundColor Yellow
$tagMessage = "Release v$newVersion"
if ($Message) {
    $tagMessage += "`n`n$Message"
}

git tag -a "v$newVersion" -m $tagMessage

# Mostrar resultado
Write-Host "`n✅ Versionamento concluído com sucesso!" -ForegroundColor Green
Write-Host "📦 Nova versão: v$newVersion" -ForegroundColor Cyan
Write-Host "🏷️ Tag criada: v$newVersion" -ForegroundColor Cyan

# Mostrar próximos passos
Write-Host "`n🚀 Próximos passos:" -ForegroundColor Yellow
Write-Host "1. git push origin master" -ForegroundColor White
Write-Host "2. git push origin v$newVersion" -ForegroundColor White
Write-Host "3. Criar release no GitHub (opcional)" -ForegroundColor White

# Mostrar log recente
Write-Host "`n📋 Commits recentes:" -ForegroundColor Yellow
git log --oneline --decorate -5