FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.hermes/bin:$PATH" \
    HERMES_HOME=/root/.hermes

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl bash ca-certificates git nodejs npm python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["hermes", "gateway"]
