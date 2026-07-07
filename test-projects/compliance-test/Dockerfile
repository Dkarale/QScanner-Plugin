FROM ubuntu:20.04

# TD-15: Dockerfile with intentional CIS Docker Benchmark violations for compliance testing
#
# FAIL controls (expected in scan results):
#   CIS DI-4.1  — Image should not run as root (no USER directive)
#   CIS DI-4.9  — HEALTHCHECK instruction should be set (missing)
#   CIS DI-4.2  — Trusted base images only (ubuntu:20.04 without digest pinning)
#   CIS DI-4.6  — COPY preferred over ADD (using ADD below)

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Intentional violation: ADD instead of COPY (CIS DI-4.6)
ADD https://example.com/app.tar.gz /tmp/

WORKDIR /app

# No USER directive — runs as root (CIS DI-4.1 FAIL)
# No HEALTHCHECK — (CIS DI-4.9 FAIL)

CMD ["/bin/bash"]
