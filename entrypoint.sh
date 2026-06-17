#!/bin/bash
set -e

# Generate .env
cat > ${HERMES_HOME}/.env << EOF
OPENAI_API_KEY=${OPENAI_API_KEY}
OPENAI_BASE_URL=${OPENAI_BASE_URL}
TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}
TELEGRAM_ENABLED=true
EOF

# Generate config.yaml dengan env var yang sudah ter-expand
cat > ${HERMES_HOME}/config/config.yaml << EOF
model:
  provider: openai
  model: accounts/fireworks/models/llama-v3p3-70b-instruct
  base_url: ${OPENAI_BASE_URL}

gateway:
  port: 8000
  allow_all: true

telegram:
  enabled: true
  bot_token: ${TELEGRAM_BOT_TOKEN}
  allowed_users:
    - ${TELEGRAM_ALLOWED_USERS}
EOF

exec hermes gateway
