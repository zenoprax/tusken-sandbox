FROM quay.io/fedora/fedora:44

RUN dnf -y update \
    && dnf -y install \
    git \
    ripgrep \
    jq

RUN curl -fsSL https://opencode.ai/install | bash

ENV PATH="/root/.opencode/bin:$PATH"

CMD ["opencode", "--auto"]
