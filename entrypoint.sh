#!/usr/bin/env bash
set -e

HERMES_HOME="${HERMES_HOME:-/root/.hermes}"
mkdir -p "$HERMES_HOME/config"

# Tulis .env runtime
{
  [ -n "$GROQ_API_KEY" ]      && echo "GROQ_API_KEY=$GROQ_API_KEY"
  [ -n "$GROQ_API_KEY_2" ]    && echo "GROQ_API_KEY_2=$GROQ_API_KEY_2"
  [ -n "$GROQ_API_KEY_3" ]    && echo "GROQ_API_KEY_3=$GROQ_API_KEY_3"
  [ -n "$FIREWORKS_API_KEY" ] && echo "FIREWORKS_API_KEY=$FIREWORKS_API_KEY"
  [ -n "$TELEGRAM_BOT_TOKEN" ] && echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN"
} > "$HERMES_HOME/.env"

# Tulis config.yaml
cat > "$HERMES_HOME/config/config.yaml" << EOF
model:
  provider: custom
  default: ${HERMES_MODEL:-llama-3.3-70b-versatile}
  base_url: ${OPENAI_BASE_URL:-https://api.groq.com/openai/v1}
  api_key: ${GROQ_API_KEY}
EOF

# Tambah Fireworks fallback jika ada
if [ -n "$FIREWORKS_API_KEY" ]; then
cat >> "$HERMES_HOME/config/config.yaml" << EOF

fallback_providers:
  - provider: custom
    base_url: https://api.fireworks.ai/inference/v1
    api_key: $FIREWORKS_API_KEY
    model: ${FIREWORKS_FALLBACK_MODEL:-accounts/fireworks/models/llama-v3p1-70b-instruct}
EOF
fi

exec "$@"
