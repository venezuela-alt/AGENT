FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.hermes/bin:$PATH" \
    HERMES_HOME=/root/.hermes \
    GROQ_API_KEY=${GROQ_API_KEY} \
    HERMES_MODEL=groq/llama-3.3-70b-versatile

RUN apt-get update && apt-get install -y \
    curl bash ca-certificates git nodejs npm python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Pre-configure Groq
RUN mkdir -p ${HERMES_HOME} && \
    echo "GROQ_API_KEY=${GROQ_API_KEY}" > ${HERMES_HOME}/.env && \
    mkdir -p ${HERMES_HOME}/config && \
    echo 'model:' > ${HERMES_HOME}/config/config.yaml && \
    echo '  provider: groq' >> ${HERMES_HOME}/config/config.yaml && \
    echo '  model: llama-3.3-70b-versatile' >> ${HERMES_HOME}/config/config.yaml

EXPOSE 8000

CMD ["hermes", "gateway"]
