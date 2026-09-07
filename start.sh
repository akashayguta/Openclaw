#!/bin/sh
set -e

mkdir -p /data/.openclaw/workspace

echo "Starting OpenClaw..."
echo "OpenClaw version:"
openclaw --version

exec openclaw gateway run --port 18789 --verbose
