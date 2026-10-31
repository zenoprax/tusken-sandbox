FROM mirror.gcr.io/library/debian:trixie-slim@sha256:f6b08b09a05725f9431502d3b5714f5c4576e82c1a84fa1debe0c24a7e0c3ec4
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

# OpenCode Config
ENV OPENCODE_DISABLE_AUTOUPDATE=true
ARG OPENCODE_VERSION=v2.2.5
RUN curl -fsSL -o /tmp/opencode.tar.gz \
        "https://github.com/anomalyco/opencode/releases/download/${OPENCODE_VERSION}/opencode-linux-x64.tar.gz" \
    && tar -xzf /tmp/opencode.tar.gz -C /usr/local/bin opencode \
    && chmod 755 /usr/local/bin/opencode \
    && rm -f /tmp/opencode.tar.gz

# User Config
RUN useradd --create-home --uid 1000 --shell /bin/bash opencode \
    && install -d -o opencode -g opencode /workspace

USER opencode
RUN opencode debug config \
    && opencode debug paths \
    && opencode debug --help

WORKDIR /workspace
CMD ["opencode", "--auto"]
