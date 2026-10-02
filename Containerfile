FROM quay.io/fedora/fedora-minimal:46

RUN dnf -y install \
    git \
    jq \
    ripgrep \
    make \
    patch \
    diffutils \
    gzip \
    xz \
    zstd \
    tar \
    python3 \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Release tag of anomalyco/opencode, bumped by Renovate (see renovate.jsonc).
# Deliberately pinned one release behind so the bot has a bump to propose.
ARG OPENCODE_VERSION=v1.18.34

RUN curl -fsSL -o /tmp/opencode.tar.gz \
        "https://github.com/anomalyco/opencode/releases/download/${OPENCODE_VERSION}/opencode-linux-x64.tar.gz" \
    && tar -xzf /tmp/opencode.tar.gz -C /usr/local/bin opencode \
    && chmod 755 /usr/local/bin/opencode \
    && rm -f /tmp/opencode.tar.gz \
    && opencode --version

CMD ["opencode", "--auto"]
