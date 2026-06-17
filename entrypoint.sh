#!/usr/bin/env bash
set -e

HERMES_HOME="${HERMES_HOME:-/root/.hermes}"
CONFIG_DIR="$HERMES_HOME/config"
ENV_FILE="$HERMES_HOME/.env"

mkdir -p "$CONFIG_DIR"

{
  [ -n "$GROQ_API_KEY" ]    && echo "GROQ_API_KEY=$GROQ_API_KEY"
  [ -n "$GROQ_API_KEY_2" ]  && echo "GROQ_API_KEY_2=$GROQ_API_KEY_2"
  [ -n "$GROQ_API_KEY_3" ]  && echo "GROQ_API_KEY_3=$GROQ_API_KEY_3"
  [ -n "$FIREWORKS_API_KEY" ] && echo "FIREWORKS_API_KEY=$FIREWORKS_API_KEY"
  [ -n "$TELEGRAM_BOT_TOKEN" ] && echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN"
} > "$ENV_FILE"

GROQ_KEYS=()
[ -n "$GROQ_API_KEY" ]   && GROQ_KEYS+=("$GROQ_API_KEY")
[ -n "$GROQ_API_KEY_2" ] && GROQ_KEYS+=("$GROQ_API_KEY_2")
[ -n "$GROQ_API_KEY_3" ] && GROQ_KEYS+=("$GROQ_API_KEY_3")

if [ ${#GROQ_KEYS[@]} -eq 0 ]; then
  echo "ERROR: At least GROQ_API_KEY must be set." >&2
  exit 1
fi

FIREWORKS_MODEL="${FIREWORKS_FALLBACK_MODEL:-accounts/fireworks/models/llama-v3p1-70b-instruct}"

cat > "$CONFIG_DIR/config.yaml" << YAML
model:
  provider: groq
  default: llama-3.3-70b-versatile

providers:
  groq:
    api_keys:
$(for key in "${GROQ_KEYS[@]}"; do echo "      - $key"; done)
YAML

if [ -n "$FIREWORKS_API_KEY" ]; then
cat >> "$CONFIG_DIR/config.yaml" << YAML

fallback_providers:
  - provider: custom
    base_url: https://api.fireworks.ai/inference/v1
    api_key: ${FIREWORKS_API_KEY}
    model: $FIREWORKS_MODEL
YAML
fi

cat >> "$CONFIG_DIR/config.yaml" << YAML

credential_pool_strategies:
  groq: round_robin
YAML

exec "$@"
