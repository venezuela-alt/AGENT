#!/usr/bin/env bash
set -e
HERMES_HOME="${HERMES_HOME:-/root/.hermes}"
mkdir -p "$HERMES_HOME/config"

{
  [ -n "$OPENAI_API_KEY" ]     && echo "OPENAI_API_KEY=$OPENAI_API_KEY"
  [ -n "$TELEGRAM_BOT_TOKEN" ] && echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN"
} > "$HERMES_HOME/.env"

cat > "$HERMES_HOME/config/config.yaml" << 'EOF'
model:
  default: accounts/fireworks/models/llama-v3p3-70b-instruct
  provider: custom:fireworks

custom_providers:
  - name: fireworks
    base_url: https://api.fireworks.ai/inference/v1
    key_env: OPENAI_API_KEY
EOF

exec "$@"
