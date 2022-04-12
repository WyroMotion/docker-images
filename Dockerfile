FROM gcc:11

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install dependencies
RUN echo 'deb http://deb.debian.org/debian bullseye-backports main' > /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
    # Core Dependencies
    build-essential \
    cmake/bullseye-backports \
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
