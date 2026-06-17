FROM nousresearch/hermes-agent:latest

ENV HERMES_HOME=/opt/data

EXPOSE 8642

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8642/health || exit 1

CMD ["hermes", "gateway", "run"]
