FROM quay.io/fedora/fedora-minimal:44

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

RUN curl -fsSL https://opencode.ai/install | bash

ENV PATH="/root/.opencode/bin:$PATH"

CMD ["opencode", "--auto"]
