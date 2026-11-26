FROM mirror.gcr.io/library/debian:trixie-slim@sha256:8aa5a7bf5a1955bddbe7d74fcdd0b91ab30e74362a8b73af672b0481b35b44a0
ENV LANG=C.UTF-8

# Package Config
COPY packages.txt /tmp/packages.txt
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && sed 's/#.*//' /tmp/packages.txt \
        | xargs -r apt-get install -y \
    && apt autopurge \
    && rm -rf /var/lib/apt/lists/* /tmp/packages.txt

# Git Config
RUN git config --system core.excludesFile /etc/gitignore \
    && printf '%s\n' '.opencode/' > /etc/gitignore \
    && printf '%s\n' '.local/' >> /etc/gitignore

# User Config
RUN useradd --create-home --uid 1000 --shell /bin/bash opencode \
    && install -d -o opencode -g opencode /workspace

# OpenCode Config
ARG OPENCODE_VERSION=v2.4.2
RUN curl -fsSL -o /tmp/opencode.tar.gz \
        "https://github.com/anomalyco/opencode/releases/download/${OPENCODE_VERSION}/opencode-linux-x64.tar.gz" \
    && tar -xzf /tmp/opencode.tar.gz -C /usr/local/bin opencode \
    && chmod 755 /usr/local/bin/opencode \
    && rm -f /tmp/opencode.tar.gz

USER opencode
RUN opencode debug config \
    && opencode debug paths \
    && opencode debug --help

WORKDIR /workspace
CMD ["opencode", "--auto"]
