FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.hermes/bin:$PATH" \
    HERMES_HOME=/root/.hermes

RUN apt-get update && apt-get install -y \
    curl bash ca-certificates git nodejs npm python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes Agent
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Pre-configure untuk Fireworks.ai
RUN mkdir -p ${HERMES_HOME} ${HERMES_HOME}/config && \
    echo "OPENAI_API_KEY=${OPENAI_API_KEY}" > ${HERMES_HOME}/.env && \
    echo "OPENAI_BASE_URL=${OPENAI_BASE_URL}" >> ${HERMES_HOME}/.env && \
    echo "TELEGRAM_ENABLED=${TELEGRAM_ENABLED}" >> ${HERMES_HOME}/.env && \
    echo "TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}" >> ${HERMES_HOME}/.env && \
    echo "TELEGRAM_ALLOWED_USERS=${TELEGRAM_ALLOWED_USERS}" >> ${HERMES_HOME}/.env && \
    cat > ${HERMES_HOME}/config/config.yaml << 'EOF'
model:
  provider: openai
  model: accounts/fireworks/models/llama-v3p3-70b-instruct
  base_url: https://api.fireworks.ai/inference/v1

gateway:
  port: 8000
  allow_all: true
EOF

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

CMD ["hermes", "gateway"]
