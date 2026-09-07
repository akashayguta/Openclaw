#!/bin/sh
set -e

mkdir -p /data/.openclaw/workspace

echo "Starting OpenClaw..."
openclaw --version

# Required for local Gateway mode
openclaw config set gateway.mode local

# Z.AI Coding Plan
openclaw config set models.providers.zai --strict-json --merge '{
  "baseUrl": "https://api.z.ai/api/coding/paas/v4",
  "apiKey": "${ZAI_API_KEY}",
  "api": "openai-completions"
}'

# GLM-5.3
openclaw config set agents.defaults.model.primary zai/glm-5.3

# Don't create bootstrap symlinks automatically
openclaw config set agents.defaults.skipBootstrap true

# Telegram
openclaw config set channels.telegram.enabled true
openclaw config set channels.telegram.dmPolicy allowlist
openclaw config set channels.telegram.allowFrom --strict-json "[\"${TELEGRAM_USER_ID}\"]"

echo "Configuration complete."
echo "Starting Gateway..."

exec openclaw gateway run --port 18789 --verbose
