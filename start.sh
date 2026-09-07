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
# Workspace
# --------------------------------------------------

echo "Configuring workspace..."

openclaw config set agents.defaults.workspace "$WORKSPACE"

# --------------------------------------------------
# Gateway
# --------------------------------------------------

echo "Configuring Gateway..."

openclaw config set gateway.mode local

# --------------------------------------------------
# Z.AI Coding Plan
# --------------------------------------------------

echo "Configuring Z.AI..."

openclaw config set models.providers.zai --strict-json --merge "{
  \"baseUrl\": \"https://api.z.ai/api/coding/paas/v4\",
  \"apiKey\": \"${ZAI_API_KEY}\",
  \"api\": \"openai-completions\"
}"

# --------------------------------------------------
# Default model
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
# Verify configuration
# --------------------------------------------------

echo "================================="
echo "Configuration complete"
echo "================================="

echo "Workspace:"
echo "$WORKSPACE"

echo "Model:"
openclaw config get agents.defaults.model.primary

echo "Gateway mode:"
openclaw config get gateway.mode

echo "================================="
echo "Starting OpenClaw Gateway..."
echo "================================="

# --------------------------------------------------
# Start Gateway
# --------------------------------------------------

exec openclaw gateway run --port 18789 --verbose
