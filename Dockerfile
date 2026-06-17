FROM nousresearch/hermes-agent:latest

ENV HERMES_HOME=/opt/data

CMD ["hermes", "gateway", "run"]
