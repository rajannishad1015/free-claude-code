@echo off
title Claude Code Free Launcher (Colab GPU)
chcp 65001 >nul

set PYTHONUTF8=1
set PYTHONIOENCODING=utf-8
set SCRIPT_DIR=%~dp0
set PYTHONPATH=%SCRIPT_DIR%

echo ========================================================
echo       🚀 Starting Claude Code via Free Colab GPU
echo ========================================================
echo.

:: Check if port 4000 is running
netstat -ano | findstr ":4000" | findstr "LISTENING" >nul
if %ERRORLEVEL% equ 0 (
    echo [OK] LiteLLM Proxy is already running on port 4000!
) else (
    echo [*] Starting LiteLLM Proxy in background...
    start /min "LiteLLM Proxy" cmd /c "set PYTHONUTF8=1 && set PYTHONIOENCODING=utf-8 && set PYTHONPATH=%SCRIPT_DIR% && litellm --config %SCRIPT_DIR%litellm_config.yaml --port 4000 --host 127.0.0.1"
    timeout /t 3 /nobreak >nul
)

echo [*] Launching Claude Code...
echo.
claude %*
