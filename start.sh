#!/bin/sh
set -e

mkdir -p /data/.openclaw/workspace

echo "Starting OpenClaw..."
echo "Version:"
openclaw --version

# Configure Z.AI Coding Plan
openclaw config set models.providers.zai --strict-json --merge '{
  "baseUrl": "https://api.z.ai/api/coding/paas/v4",
  "apiKey": "${ZAI_API_KEY}",
  "api": "openai-completions"
}'

# Use the flagship Coding Plan model
openclaw config set agents.defaults.model.primary zai/glm-5.3

# Disable automatic bootstrap-file creation
openclaw config set agents.defaults.skipBootstrap true

# Configure Telegram
openclaw config set channels.telegram.enabled true
openclaw config set channels.telegram.dmPolicy allowlist
openclaw config set channels.telegram.allowFrom --strict-json "[\"${TELEGRAM_USER_ID}\"]"

exec openclaw gateway run --port 18789 --verbose
