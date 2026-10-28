# PowerShell Launcher for Claude Code via LiteLLM
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"
$env:PYTHONPATH = $scriptDir

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "      🚀 Starting Claude Code via Free Colab GPU        " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

$portInUse = Get-NetTCPConnection -LocalPort 4000 -ErrorAction SilentlyContinue

if ($portInUse) {
    Write-Host "[OK] LiteLLM Proxy is already running on port 4000!" -ForegroundColor Green
} else {
    Write-Host "[*] Starting LiteLLM Proxy in background..." -ForegroundColor Yellow
    Start-Process -FilePath "litellm" -ArgumentList "--config `"$scriptDir\litellm_config.yaml`" --port 4000 --host 127.0.0.1" -WindowStyle Minimized
    Start-Sleep -Seconds 3
}

Write-Host "[*] Launching Claude Code..." -ForegroundColor Green
claude @args
