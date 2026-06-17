FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.hermes/bin:$PATH" \
    HERMES_HOME=/root/.hermes

RUN apt-get update && apt-get install -y \
    curl bash ca-certificates git nodejs npm python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Template env
RUN mkdir -p ${HERMES_HOME} && \
    echo "GROQ_API_KEY=your_groq_key_here" > ${HERMES_HOME}/.env

EXPOSE 8000

CMD ["hermes", "gateway"]
