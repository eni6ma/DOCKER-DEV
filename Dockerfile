# Development Docker Environment with Multiple Languages and Tools
FROM ubuntu:22.04 AS base

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and development tools
RUN apt-get update && apt-get install -y \
    # Essential build tools
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    pkg-config \
    # C/C++ tools
    clang \
    clang-format \
    clang-tidy \
    llvm \
    # Git and version control
    git \
    curl \
    wget \
    ca-certificates \
    # Python and pip
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    # Development tools
    vim \
    nano \
    htop \
    tree \
    unzip \
    zip \
    # Network tools
    iputils-ping \
    net-tools \
    dnsutils \
    # Shell and terminal
    bash \
    zsh \
    fish \
    # JSON and text processing
    jq \
    # SSL certificates
    openssl \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Install Node.js (LTS version) and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn \
    && npm install -g pnpm \
    && npm install -g npm-check-updates

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Golang
ENV GO_VERSION=1.21.6
# Detect architecture and download appropriate Go binary
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        GO_ARCH="arm64"; \
    else \
        GO_ARCH="amd64"; \
    fi && \
    wget -q https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-${GO_ARCH}.tar.gz && \
    rm go${GO_VERSION}.linux-${GO_ARCH}.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH=/root/go
ENV PATH="${GOPATH}/bin:${PATH}"

# Python - upgrade pip and install common packages
RUN python3 -m pip install --upgrade pip setuptools wheel

# Install Rust tools commonly used
RUN rustup component add rustfmt clippy rust-analyzer \
    && cargo install cargo-watch \
    && cargo install cargo-audit \
    && cargo install cargo-expand \
    && cargo install cargo-udeps \
    && cargo install cargo-tree \
    && cargo install cargo-outdated

# Install common Go tools (disable CGO for problematic packages)
RUN CGO_ENABLED=0 go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest \
    && CGO_ENABLED=0 go install golang.org/x/tools/cmd/goimports@latest \
    && CGO_ENABLED=0 go install github.com/ramya-rao-a/go-outline@latest \
    && CGO_ENABLED=0 go install github.com/cweill/gotests/...@latest

# Install common Python tools
RUN pip3 install --break-system-packages \
    black \
    flake8 \
    mypy \
    pytest \
    pylint \
    autopep8 \
    ipython \
    ipdb

# Final stage - minimal runtime
FROM base

# Set up environment variables
ENV USER=developer
ENV HOME=/home/${USER}

# Create a non-root user
RUN useradd -m -s /bin/bash ${USER} \
    && mkdir -p ${HOME}/workspace \
    && chown -R ${USER}:${USER} ${HOME}

# Set working directory
WORKDIR ${HOME}/workspace

# Switch to non-root user
USER ${USER}

# Set up the environment
ENV RUSTUP_HOME=$HOME/.rustup
ENV CARGO_HOME=$HOME/.cargo
ENV PATH="${CARGO_HOME}/bin:${PATH}"

# Ensure Rust is in PATH for the user
RUN echo 'source $HOME/.cargo/env' >> ~/.bashrc

# Labels for metadata
LABEL maintainer="developer@example.com"
LABEL description="Multi-language development environment with Rust, Go, Python, Node.js, and C++"
LABEL version="1.0"

# Keep container running for development
CMD ["/bin/bash"]

