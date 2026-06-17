#!/usr/bin/env bash
set -e
HERMES_HOME="${HERMES_HOME:-/root/.hermes}"
mkdir -p "$HERMES_HOME/config"
{
  [ -n "$GROQ_API_KEY" ]      && echo "GROQ_API_KEY=$GROQ_API_KEY"
  [ -n "$GROQ_API_KEY_2" ]    && echo "GROQ_API_KEY_2=$GROQ_API_KEY_2"
  [ -n "$GROQ_API_KEY_3" ]    && echo "GROQ_API_KEY_3=$GROQ_API_KEY_3"
  [ -n "$ANTHROPIC_API_KEY" ] && echo "ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY"
  [ -n "$FIREWORKS_API_KEY" ] && echo "FIREWORKS_API_KEY=$FIREWORKS_API_KEY"
  [ -n "$TELEGRAM_BOT_TOKEN" ] && echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN"
} > "$HERMES_HOME/.env"
cat > "$HERMES_HOME/config/config.yaml" << EOF
model:
  provider: anthropic
  default: claude-opus-4-6
  base_url: ${ANTHROPIC_BASE_URL:-https://agentrouter.org}
  api_key: ${ANTHROPIC_API_KEY}
EOF
exec "$@"
