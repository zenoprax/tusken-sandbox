FROM mirror.gcr.io/library/debian:trixie-slim@sha256:a72b4433de1cf7d6bae0c4cee74d0547f58601a643b3375f070c51600d63b6b2
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
ARG OPENCODE_VERSION=v2.2.5
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
