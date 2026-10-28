#!/bin/bash
# Linux/macOS Launcher for Claude Code via LiteLLM

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PYTHONPATH="$SCRIPT_DIR"
export PYTHONUTF8=1
export PYTHONIOENCODING=utf-8

echo "========================================================"
echo "      🚀 Starting Claude Code via Free Colab GPU        "
echo "========================================================"
echo ""

# Check if port 4000 is running
if lsof -Pi :4000 -sTCP:LISTEN -t >/dev/null ; then
    echo "[OK] LiteLLM Proxy is already running on port 4000!"
else
    echo "[*] Starting LiteLLM Proxy in background..."
    litellm --config "$SCRIPT_DIR/litellm_config.yaml" --port 4000 --host 127.0.0.1 > /dev/null 2>&1 &
    sleep 3
fi

echo "[*] Launching Claude Code..."
echo ""
claude "$@"
