# Source: https://github.com/dotnet/dotnet-docker
FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-jammy as build

ARG TARGETOS="linux"
ARG TARGETARCH_1
ARG TARGETARCH_2
ARG RUNNER_VERSION="2.317.0"
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.6.0
ARG DOCKER_VERSION=25.0.4
ARG BUILDX_VERSION=0.13.1

RUN apt update -y && apt install curl unzip -y

WORKDIR /actions-runner
RUN export RUNNER_ARCH=${TARGETARCH_1} \
    && if [ "$RUNNER_ARCH" = "amd64" ]; then export RUNNER_ARCH=x64 ; fi \
    && curl -f -L -o runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-${TARGETOS}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./runner.tar.gz \
    && rm runner.tar.gz

RUN curl -f -L -o runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
    && unzip ./runner-container-hooks.zip -d ./k8s \
    && rm runner-container-hooks.zip

RUN curl -fLo docker.tgz https://download.docker.com/${TARGETOS}/static/stable/${TARGETARCH_2}/docker-${DOCKER_VERSION}.tgz \
    && tar zxvf docker.tgz \
    && rm -rf docker.tgz \
    && mkdir -p /usr/local/lib/docker/cli-plugins \
    && curl -fLo /usr/local/lib/docker/cli-plugins/docker-buildx \
    "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-${TARGETARCH_1}" \
    && chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx

FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-jammy

ARG TARGETARCH_1
ARG TARGETARCH_2

ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_MANUALLY_TRAP_SIG=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1
# some setup actions depend on ImageOS variable
# https://github.com/actions/runner-images/issues/345
ENV ImageOS=ubuntu20

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    sudo \
    lsb-release \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    groff \
    jq \
    less \
    libssl-dev \
    wget \
    xz-utils \
    zip \
    unzip \
    python3-pip \
    python-is-python3 \
    && rm -rf /var/lib/apt/lists/*

# set up the runner environment,
# based on https://github.com/actions/runner/blob/v2.309.0/images/Dockerfile
RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && groupadd docker --gid 123 \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

# some setup actions store cache into /opt/hostedtoolcache
ENV RUNNER_TOOL_CACHE /opt/hostedtoolcache
RUN mkdir /opt/hostedtoolcache \
    && chown runner:docker /opt/hostedtoolcache

# yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${TARGETARCH_1} && \
    chmod +x /usr/local/bin/yq

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${TARGETARCH_1}/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# kustomize
ARG KUSTOMIZE_VER="v5.1.1"
RUN curl --location --remote-name "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VER}/kustomize_${KUSTOMIZE_VER}_linux_${TARGETARCH_1}.tar.gz" && \
    tar -xvf kustomize_${KUSTOMIZE_VER}_linux_${TARGETARCH_1}.tar.gz && \
    chmod a+x kustomize && \
    mv kustomize /usr/local/bin/kustomize


# security stuffs - disable due to missing some important commands
# COPY hardening-os.sh /root/hardening-os.sh
# RUN sh /root/hardening-os.sh

WORKDIR /home/runner

COPY --chown=runner:docker --from=build /actions-runner .

RUN install -o root -g root -m 755 docker/* /usr/bin/ && rm -rf docker

USER runner