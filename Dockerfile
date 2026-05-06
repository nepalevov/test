FROM debian:bookworm-slim AS source01
RUN printf "cached source 01\n" > /source.txt

FROM debian:bookworm-slim AS source02
RUN printf "cached source 02\n" > /source.txt

FROM debian:bookworm-slim AS source03
RUN printf "cached source 03\n" > /source.txt

FROM debian:bookworm-slim AS source04
RUN printf "cached source 04\n" > /source.txt

FROM debian:bookworm-slim AS source05
RUN printf "cached source 05\n" > /source.txt

FROM debian:bookworm-slim AS source06
RUN printf "cached source 06\n" > /source.txt

FROM debian:bookworm-slim AS source07
RUN printf "cached source 07\n" > /source.txt

FROM debian:bookworm-slim AS source08
RUN printf "cached source 08\n" > /source.txt

FROM debian:bookworm-slim AS source09
RUN printf "cached source 09\n" > /source.txt

FROM debian:bookworm-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Change LAST_LAYER_NONCE per build to force only the last layer to rebuild.
ARG LAST_LAYER_NONCE=0
ARG LAST_LAYER_PAYLOAD_MB=1024

WORKDIR /heavy-build

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

COPY --from=source01 /source.txt /heavy-build/cached-sources/source01.txt
COPY --from=source02 /source.txt /heavy-build/cached-sources/source02.txt
COPY --from=source03 /source.txt /heavy-build/cached-sources/source03.txt
COPY --from=source04 /source.txt /heavy-build/cached-sources/source04.txt
COPY --from=source05 /source.txt /heavy-build/cached-sources/source05.txt
COPY --from=source06 /source.txt /heavy-build/cached-sources/source06.txt
COPY --from=source07 /source.txt /heavy-build/cached-sources/source07.txt
COPY --from=source08 /source.txt /heavy-build/cached-sources/source08.txt
COPY --from=source09 /source.txt /heavy-build/cached-sources/source09.txt

RUN mkdir -p /heavy-build/layer-last \
    && printf "%s\n" "${LAST_LAYER_NONCE}" > /heavy-build/layer-last/nonce.txt \
    && dd if=/dev/urandom of=/heavy-build/layer-last/payload-1g.bin bs=1M count=${LAST_LAYER_PAYLOAD_MB} status=none \
    && sha256sum /heavy-build/layer-last/payload-1g.bin > /heavy-build/layer-last/payload-1g.sha256

EXPOSE 8080

CMD ["bash", "-lc", "while true; do { printf 'HTTP/1.1 200 OK\\r\\nContent-Type: text/plain; charset=utf-8\\r\\nContent-Length: 2\\r\\nConnection: close\\r\\n\\r\\nOK'; } | nc -l -p 8080 -q 1; done"]
