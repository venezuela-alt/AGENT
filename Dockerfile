FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl bash nodejs npm python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes Agent
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

ENV PATH="/root/.hermes/bin:$PATH"

CMD hermes config set model groq/llama-3.3-70b-versatile && hermes gateway
