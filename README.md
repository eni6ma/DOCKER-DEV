# DOCKER-DEV
Dev Docker Image

## Overview

A comprehensive, self-contained Docker image with multiple programming languages and development tools, ready for portable development environments.

## Included Tools

### Languages & Runtimes
- **Rust** - Compiler, Cargo, rustfmt, clippy, rust-analyzer, cargo-watch, cargo-audit, cargo-expand, cargo-udeps, cargo-tree, cargo-outdated
- **Go** - Go 1.21.6 with golangci-lint, goimports, gotests
- **Python** - Python 3 with black, flake8, mypy, pytest, pylint, autopep8, ipython, ipdb
- **Node.js** - Node.js LTS v20.x with npm, yarn, pnpm, npm-check-updates
- **C/C++** - GCC, G++, Clang, clang-format, clang-tidy, CMake, Make, pkg-config

### Development Tools
- **Version Control**: Git
- **Build Tools**: Make, CMake
- **Editors**: Vim, Nano
- **System Tools**: Bash, Zsh, Fish, htop, tree
- **Utilities**: curl, wget, jq, ping, net-tools

## Quick Start

### Build the Image
```bash
make build
# or
./build.sh
# or
docker build -t dev-environment:latest .
```

### Run the Container
```bash
make run
# or
docker-compose up
```

### Test Installation
```bash
make test
```

### Push to Registry
```bash
make push REGISTRY=your-registry.com
# or
./build.sh --registry your-registry.com --push
```

## Usage Examples

### Create a Rust Project
```bash
cd workspace
cargo new my_project
cd my_project
cargo run
```

### Create a Go Project
```bash
cd workspace
mkdir my_project && cd my_project
go mod init example.com/my_project
go run main.go
```

### Create a Node.js Project
```bash
cd workspace
npm init -y
yarn add express
```

### Create a Python Project
```bash
cd workspace
python3 -m venv venv
source venv/bin/activate
pip install requests
```

## Running with Docker Compose

Edit `docker-compose.yml` to customize volume mounts for:
- SSH keys
- Git config
- AWS credentials
- GPG keys

## Verifying Tools

Run the verification script inside the container:
```bash
./verify.sh
```

Or use the Makefile:
```bash
make test
```

## Makefile Targets

- `make build` - Build the Docker image
- `make push` - Build and push to registry
- `make run` - Run container interactively
- `make shell` - Start a shell in the container
- `make test` - Test all installed tools
- `make clean` - Remove the Docker image
- `make help` - Show all available targets

## Security

- Container runs as non-root user (`developer`)
- All installations done in user space where possible
- HTTPS certificates included

## Notes

- Ubuntu 22.04 base image
- All tools installed and ready to use
- Workspace mounted at `/home/developer/workspace`
- Supports Bash, Zsh, and Fish shells
- All development tools pre-installed and verified
