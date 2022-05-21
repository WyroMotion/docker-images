FROM ubuntu:22.04

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install dependencies
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
    # Core Dependencies
    build-essential \
    crossbuild-essential-arm64 \
    cmake \
    ninja-build \
    # Linters / Checkers
    clang-tidy \
    clang-format \
    cppcheck \
    valgrind \
    # Vcpkg Dependencies
    zip \
    # Utility Dependencies
    git \
    ccache \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Create the non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

USER $USERNAME
