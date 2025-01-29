FROM ghcr.io/elek/storagenode-runner:latest

RUN apt-get update && apt-get install -y curl bc && rm -rf /var/lib/apt/lists/*

ENV RMZ_VERSION="2.2.0"
ENV RMZ_BIN="/usr/local/bin/rmz"

RUN curl -sL "https://github.com/SUPERCILEX/fuc/releases/download/${RMZ_VERSION}/rmz-x86_64-unknown-linux-gnu" -o "$RMZ_BIN"
RUN chmod +x "$RMZ_BIN"

COPY trash-delete.sh /usr/local/bin/trash-delete.sh
RUN chmod +x /usr/local/bin/trash-delete.sh
