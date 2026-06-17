#!/usr/bin/env bash
set -e

HERMES_HOME="${HERMES_HOME:-/root/.hermes}"
CONFIG_DIR="$HERMES_HOME/config"
ENV_FILE="$HERMES_HOME/.env"

mkdir -p "$CONFIG_DIR"

# ─────────────────────────────────────────────────────────────
# 1.  Write API keys to Hermes .env at runtime (NOT build-time)
# ─────────────────────────────────────────────────────────────
{
  # Primary Groq key
  [ -n "$GROQ_API_KEY" ]    && echo "GROQ_API_KEY=$GROQ_API_KEY"
  [ -n "$GROQ_API_KEY_2" ]  && echo "GROQ_API_KEY_2=$GROQ_API_KEY_2"
  [ -n "$GROQ_API_KEY_3" ]  && echo "GROQ_API_KEY_3=$GROQ_API_KEY_3"

  # Fireworks AI fallback
  [ -n "$FIREWORKS_API_KEY" ] && echo "FIREWORKS_API_KEY=$FIREWORKS_API_KEY"

  # Other optional keys
  [ -n "$TELEGRAM_BOT_TOKEN" ] && echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN"
  [ -n "$OPENROUTER_API_KEY" ] && echo "OPENROUTER_API_KEY=$OPENROUTER_API_KEY"
} > "$ENV_FILE"

# ─────────────────────────────────────────────────────────────
# 2.  Collect all Groq keys into an array for credential pool
# ─────────────────────────────────────────────────────────────
GROQ_KEYS=()
[ -n "$GROQ_API_KEY" ]   && GROQ_KEYS+=("$GROQ_API_KEY")
[ -n "$GROQ_API_KEY_2" ] && GROQ_KEYS+=("$GROQ_API_KEY_2")
[ -n "$GROQ_API_KEY_3" ] && GROQ_KEYS+=("$GROQ_API_KEY_3")

if [ ${#GROQ_KEYS[@]} -eq 0 ]; then
  echo "ERROR: At least GROQ_API_KEY must be set." >&2
  exit 1
fi

# ─────────────────────────────────────────────────────────────
# 3.  Build config.yaml
#     - Primary provider: Groq (with multi-key credential pool)
#     - Fallback:         Fireworks AI (if key provided)
# ─────────────────────────────────────────────────────────────
FIREWORKS_MODEL="${FIREWORKS_FALLBACK_MODEL:-accounts/fireworks/models/llama-v3p1-70b-instruct}"

cat > "$CONFIG_DIR/config.yaml" << YAML
model:
  provider: groq
  default: llama-3.3-70b-versatile

# ── Multi-key Groq credential pool ──────────────────────────
providers:
  groq:
    api_keys:
$(for key in "${GROQ_KEYS[@]}"; do echo "      - $key"; done)
YAML

# Append Fireworks fallback if key is provided
if [ -n "$FIREWORKS_API_KEY" ]; then
cat >> "$CONFIG_DIR/config.yaml" << YAML

# ── Fireworks AI fallback provider ──────────────────────────
# Kicks in automatically when all Groq keys are unhealthy
fallback_providers:
  - provider: custom
    base_url: https://api.fireworks.ai/inference/v1
    api_key: ${FIREWORKS_API_KEY}
    model: $FIREWORKS_MODEL
YAML
fi

cat >> "$CONFIG_DIR/config.yaml" << YAML

# ── Credential pool rotation strategy ───────────────────────
credential_pool_strategies:
  groq: round_robin
YAML

echo "=== Hermes config written ==="
echo "  Groq keys loaded : ${#GROQ_KEYS[@]}"
[ -n "$FIREWORKS_API_KEY" ] && echo "  Fireworks fallback: ENABLED ($FIREWORKS_MODEL)" || echo "  Fireworks fallback: disabled (no key)"
echo ""

# ─────────────────────────────────────────────────────────────
# 4.  Launch
# ─────────────────────────────────────────────────────────────
exec "$@"
