FROM public.ecr.aws/docker/library/debian:trixie-20261005-slim
ENV LANG=C.UTF-8

# Package Config
COPY packages.txt /tmp/packages.txt
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && sed 's/#.*//' /tmp/packages.txt \
        | xargs -r apt-get install -y \
    && apt autopurge \
    && rm -rf /var/lib/apt/lists/* /tmp/packages.txt

# OpenCode Config
ENV OPENCODE_DISABLE_AUTOUPDATE=true
ARG OPENCODE_VERSION=v1.18.35
RUN curl -fsSL -o /tmp/opencode.tar.gz \
        "https://github.com/anomalyco/opencode/releases/download/${OPENCODE_VERSION}/opencode-linux-x64.tar.gz" \
    && tar -xzf /tmp/opencode.tar.gz -C /usr/local/bin opencode \
    && chmod 755 /usr/local/bin/opencode \
    && rm -f /tmp/opencode.tar.gz

# User Config
RUN useradd --create-home --uid 1000 --shell /bin/bash opencode \
    && install -d -o opencode -g opencode /workspace

RUN printf '%s\n' \
    'opencode ALL=(root) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get' \
    > /etc/sudoers.d/opencode \
    && chmod 0440 /etc/sudoers.d/opencode

USER opencode
RUN sudo apt-get update
RUN opencode debug config \
    && opencode debug paths \
    && opencode debug info \
    && opencode debug startup

WORKDIR /workspace
CMD ["opencode", "--auto"]
