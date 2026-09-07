#!/bin/sh
set -e

OPENCLAW_DIR="/data/.openclaw"
WORKSPACE="$OPENCLAW_DIR/workspace"

mkdir -p "$WORKSPACE"

echo "================================="
echo "Starting OpenClaw"
echo "================================="

openclaw --version

# --------------------------------------------------
# AGENTS.md
# Copy the GitHub version to the persistent disk
# only on first initialization.
# --------------------------------------------------

if [ ! -f "$WORKSPACE/AGENTS.md" ]; then
    if [ -f "/app/AGENTS.md" ]; then
        cp "/app/AGENTS.md" "$WORKSPACE/AGENTS.md"
        echo "AGENTS.md installed."
    else
        echo "WARNING: /app/AGENTS.md not found."
    fi
else
    echo "Existing AGENTS.md found. Keeping it."
fi

# --------------------------------------------------
# Gateway configuration
# --------------------------------------------------

echo "Configuring Gateway..."

openclaw config set gateway.mode local

# --------------------------------------------------
# Z.AI Coding Plan
# --------------------------------------------------

echo "Configuring Z.AI..."

openclaw config set models.providers.zai --strict-json --merge '{
  "baseUrl": "https://api.z.ai/api/coding/paas/v4",
  "apiKey": "${ZAI_API_KEY}",
  "api": "openai-completions"
}'

# --------------------------------------------------
# Default AI model
# --------------------------------------------------

echo "Setting GLM-5.3..."

openclaw config set agents.defaults.model.primary zai/glm-5.3

# --------------------------------------------------
# Disable automatic bootstrap generation
# --------------------------------------------------

openclaw config set agents.defaults.skipBootstrap true

# --------------------------------------------------
# Telegram
# --------------------------------------------------

echo "Configuring Telegram..."

openclaw config set channels.telegram.enabled true

openclaw config set channels.telegram.dmPolicy allowlist

openclaw config set channels.telegram.allowFrom \
    --strict-json "[\"${TELEGRAM_USER_ID}\"]"

# --------------------------------------------------
# Final information
# --------------------------------------------------

echo "================================="
echo "Configuration complete."
echo "Workspace: $WORKSPACE"
echo "Model: zai/glm-5.3"
echo "Telegram allowlist: enabled"
echo "================================="

# --------------------------------------------------
# Start OpenClaw Gateway
# --------------------------------------------------

exec openclaw gateway run --port 18789 --verbose
