# Quick Start Guide

## Build

```bash
# Option 1: Using Make
make build

# Option 2: Using build script
./build.sh

# Option 3: Direct Docker
docker build -t dev-environment:latest .
```

## Run

```bash
# Option 1: Using Make
make run

# Option 2: Using docker-compose
docker-compose up

# Option 3: Direct Docker
docker run -it -v $(pwd)/workspace:/home/developer/workspace dev-environment:latest bash
```

## Test

```bash
make test
```

## Push to Registry

```bash
# Using Make
make push REGISTRY=your-registry.com

# Using build script
./build.sh --registry your-registry.com --push
```

## Available Commands

```bash
make help         # Show all available commands
make build        # Build the image
make run          # Run container
make shell        # Get shell in container
make test         # Test all tools
make clean        # Remove image
```

## What's Inside

### Languages
- Rust (with cargo tools)
- Go 1.21.6
- Python 3
- Node.js 20.x LTS
- C/C++ (GCC, Clang)

### Tools
- Git, curl, wget, jq
- Vim, nano, htop, tree
- Bash, Zsh, Fish
- Build tools (make, cmake)

## First Steps After Running

```bash
# Verify installation
./verify.sh

# Or check versions
rustc --version
go version
node --version
python3 --version
```

