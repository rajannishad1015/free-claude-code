# ==========================================================
# 🚀 1-Click Ollama + Qwen 2.5 Coder + Cloudflare Tunnel
# Run this file inside Google Colab (with T4 GPU enabled)
# ==========================================================

import os
import subprocess
import time
import re

print("[1/5] Installing dependencies (zstd)...")
os.system("apt-get update -qq && apt-get install -y -qq zstd")

print("\n[2/5] Installing Ollama...")
os.system("curl -fsSL https://ollama.com/install.sh | sh")

print("\n[3/5] Installing Cloudflare Tunnel (cloudflared)...")
os.system("wget -q -nc https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb")
os.system("dpkg -i cloudflared-linux-amd64.deb > /dev/null 2>&1")

print("\n[4/5] Starting Ollama server with full remote access...")
# Set remote permissions so external tunnel requests are not rejected with 403 Forbidden
env = os.environ.copy()
env["OLLAMA_ORIGINS"] = "*"
env["OLLAMA_HOST"] = "0.0.0.0"

# Kill any existing instances
os.system("pkill -f 'ollama serve'")
os.system("pkill -f 'cloudflared'")

subprocess.Popen(["ollama", "serve"], env=env)
time.sleep(3)

# Default model: qwen2.5-coder:7b (fast & lightweight)
# You can change to 'qwen2.5-coder:14b' for smarter coding (requires ~9GB VRAM)
MODEL_NAME = "qwen2.5-coder:7b"
print(f"\n[5/5] Downloading {MODEL_NAME} to GPU memory...")
os.system(f"ollama pull {MODEL_NAME}")

print("\n🌐 Starting Cloudflare Public Tunnel to Ollama...")
tunnel_proc = subprocess.Popen(
    ["cloudflared", "tunnel", "--url", "http://127.0.0.1:11434", "--http-host-header", "localhost:11434"],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    text=True
)

public_url = None
for line in tunnel_proc.stdout:
    match = re.search(r"https://[a-zA-Z0-9-]+\.trycloudflare\.com", line)
    if match:
        public_url = match.group(0)
        break

print("\n" + "=" * 65)
print("🎉 YOUR FREE OLLAMA PUBLIC TUNNEL URL IS READY:")
print(f"👉 {public_url}")
print("=" * 65)
print("\n[!] Keep this Colab tab open while using Claude Code.")
