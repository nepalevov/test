FROM debian:bookworm-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# By default: 10 layers * 30 seconds = 5 minutes build time
ARG BUILD_DELAY_SECONDS=30
ARG PAYLOAD_MB_PER_LAYER=48

WORKDIR /heavy-build

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    coreutils \
    gzip \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /heavy-build/layer01 \
    && dd if=/dev/urandom of=/heavy-build/layer01/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer01/payload.bin > /heavy-build/layer01/payload.sha256 \
    && gzip -9 /heavy-build/layer01/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

RUN mkdir -p /heavy-build/layer02 \
    && dd if=/dev/urandom of=/heavy-build/layer02/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer02/payload.bin > /heavy-build/layer02/payload.sha256 \
    && gzip -9 /heavy-build/layer02/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

RUN mkdir -p /heavy-build/layer03 \
    && dd if=/dev/urandom of=/heavy-build/layer03/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer03/payload.bin > /heavy-build/layer03/payload.sha256 \
    && gzip -9 /heavy-build/layer03/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

RUN mkdir -p /heavy-build/layer04 \
    && dd if=/dev/urandom of=/heavy-build/layer04/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer04/payload.bin > /heavy-build/layer04/payload.sha256 \
    && gzip -9 /heavy-build/layer04/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

RUN mkdir -p /heavy-build/layer05 \
    && dd if=/dev/urandom of=/heavy-build/layer05/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer05/payload.bin > /heavy-build/layer05/payload.sha256 \
    && gzip -9 /heavy-build/layer05/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

RUN mkdir -p /heavy-build/layer06 \
    && dd if=/dev/urandom of=/heavy-build/layer06/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer06/payload.bin > /heavy-build/layer06/payload.sha256 \
    && gzip -9 /heavy-build/layer06/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

RUN mkdir -p /heavy-build/layer07 \
    && dd if=/dev/urandom of=/heavy-build/layer07/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer07/payload.bin > /heavy-build/layer07/payload.sha256 \
    && gzip -9 /heavy-build/layer07/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

RUN mkdir -p /heavy-build/layer08 \
    && dd if=/dev/urandom of=/heavy-build/layer08/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer08/payload.bin > /heavy-build/layer08/payload.sha256 \
    && gzip -9 /heavy-build/layer08/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

RUN mkdir -p /heavy-build/layer09 \
    && dd if=/dev/urandom of=/heavy-build/layer09/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer09/payload.bin > /heavy-build/layer09/payload.sha256 \
    && gzip -9 /heavy-build/layer09/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

RUN mkdir -p /heavy-build/layer10 \
    && dd if=/dev/urandom of=/heavy-build/layer10/payload.bin bs=1M count=${PAYLOAD_MB_PER_LAYER} status=none \
    && sha256sum /heavy-build/layer10/payload.bin > /heavy-build/layer10/payload.sha256 \
    && gzip -9 /heavy-build/layer10/payload.bin \
    && sleep "${BUILD_DELAY_SECONDS}"

EXPOSE 8080

CMD ["bash", "-lc", "while true; do { printf 'HTTP/1.1 200 OK\\r\\nContent-Type: text/plain; charset=utf-8\\r\\nContent-Length: 2\\r\\nConnection: close\\r\\n\\r\\nOK'; } | nc -l -p 8080 -q 1; done"]
