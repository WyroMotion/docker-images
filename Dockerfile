FROM ubuntu:22.04

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV CMAKE_VERSION 3.23.1

# Install dependencies
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
    # Core Dependencies
    build-essential \
    crossbuild-essential-arm64 \
    ninja-build \
    # Linters / Checkers
    clang-tidy \
    clang-format \
    cppcheck \
    valgrind \
    # Doxygen
    doxygen \
    doxygen-latex \
    graphviz \
    # Vcpkg Dependencies
    zip \
    pkg-config \
    # Utility Dependencies
    git \
    ccache \
    # CMake Build Dependencies
    ca-certificates \
    curl \
    libssl-dev\
    # Clean up after apt-get
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    # Build our own cmake
    && curl -OL "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz" \
    && tar xzf "cmake-${CMAKE_VERSION}.tar.gz" \
    && cd "cmake-${CMAKE_VERSION}" \
    && ./bootstrap -- -DCMAKE_BUILD_TYPE:STRING=Release \
    && make install \
    && rm -rf cmake-"${CMAKE_VERSION}"*

# Create the non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

USER $USERNAME
