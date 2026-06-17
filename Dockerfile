FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.hermes/bin:$PATH" \
    HERMES_HOME=/root/.hermes

RUN apt-get update && apt-get install -y \
    curl bash ca-certificates git nodejs npm python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes Agent
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Pre-configure Fireworks.ai
RUN mkdir -p ${HERMES_HOME} ${HERMES_HOME}/config && \
    # .env
    echo "FIREWORKS_API_KEY=${FIREWORKS_API_KEY}" > ${HERMES_HOME}/.env && \
    echo "GROQ_API_KEY=${GROQ_API_KEY}" >> ${HERMES_HOME}/.env && \
    echo "GROQ_API_KEY_2=${GROQ_API_KEY_2}" >> ${HERMES_HOME}/.env && \
    # config.yaml - Force Fireworks (OpenAI compatible)
    cat > ${HERMES_HOME}/config/config.yaml << 'EOF'
model:
  provider: fireworks
  model: accounts/fireworks/models/llama-v3p3-70b-instruct
  base_url: https://api.fireworks.ai/inference/v1

# Fallback kalau perlu
fallback_chain:
  - provider: fireworks
    model: accounts/fireworks/models/deepseek-r1

gateway:
  port: 8000
EOF

EXPOSE 8000

CMD ["hermes", "gateway"]
