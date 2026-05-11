# Script para apagar a branch main remota e recriar com o estado atual do projeto
# Uso: abrir PowerShell no diretorio do projeto e executar: .\reset-github.ps1
# Requer: Git instalado, credenciais do GitHub ja configuradas (Git Credential Manager)

$ErrorActionPreference = "Stop"

$repoPath = "C:\Users\ribas\OneDrive\Desktop\faculdade\web\web-atv1\web-atv1"
$remoteUrl = "https://github.com/ribasmar/web-atv1.git"
$branch    = "main"
$commitMsg = "Initial commit"

Set-Location $repoPath

Write-Host "==> Diretorio: $repoPath" -ForegroundColor Cyan
Write-Host "==> Remote   : $remoteUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "ATENCAO: Esta operacao IRA APAGAR todo o historico da branch '$branch' no GitHub." -ForegroundColor Yellow
$confirm = Read-Host "Digite 'SIM' para continuar"
if ($confirm -ne "SIM") {
    Write-Host "Operacao cancelada." -ForegroundColor Red
    exit 1
}

if (Test-Path ".git\index.lock") {
    Write-Host "==> Removendo .git\index.lock (stale lock)" -ForegroundColor Cyan
    Remove-Item ".git\index.lock" -Force
}

Write-Host "==> Garantindo identidade do autor" -ForegroundColor Cyan
git config user.email "ribas7494@gmail.com"
git config user.name  "Rafael Ribas"

Write-Host "==> Criando branch orfa (sem historico)" -ForegroundColor Cyan
git checkout --orphan nova-main
if ($LASTEXITCODE -ne 0) { throw "Falha ao criar branch orfa" }

Write-Host "==> Adicionando arquivos do working tree (respeitando .gitignore)" -ForegroundColor Cyan
git add -A
if ($LASTEXITCODE -ne 0) { throw "Falha no git add" }

Write-Host "==> Criando commit inicial" -ForegroundColor Cyan
git commit -m $commitMsg
if ($LASTEXITCODE -ne 0) { throw "Falha no commit" }

Write-Host "==> Removendo a branch '$branch' local antiga (se existir)" -ForegroundColor Cyan
git branch -D $branch 2>$null

Write-Host "==> Renomeando branch atual para '$branch'" -ForegroundColor Cyan
git branch -m $branch
if ($LASTEXITCODE -ne 0) { throw "Falha ao renomear branch" }

Write-Host "==> Force push para origin/$branch (substituindo remoto)" -ForegroundColor Cyan
git push -f origin $branch
if ($LASTEXITCODE -ne 0) { throw "Falha no push - verifique credenciais do GitHub" }

Write-Host ""
Write-Host "OK - Branch '$branch' recriada com sucesso em $remoteUrl" -ForegroundColor Green
