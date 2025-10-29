#!/bin/bash

# Verification script to check installed tools in the Docker container

echo "=========================================="
echo "Verifying Development Environment"
echo "=========================================="
echo ""

# Function to check command existence
check_command() {
    if command -v $1 &> /dev/null; then
        echo "✓ $1 - $(command -v $1)"
        if [ -n "$2" ]; then
            $2
        fi
    else
        echo "✗ $1 - NOT FOUND"
    fi
    echo ""
}

# Check Rust
echo "=== Rust Tools ==="
check_command "rustc" "rustc --version"
check_command "cargo" "cargo --version"
check_command "rustfmt" "rustfmt --version"
check_command "clippy-driver" "clippy-driver --version"
check_command "cargo-watch" "cargo watch --version"
echo ""

# Check Go
echo "=== Go Tools ==="
check_command "go" "go version"
check_command "golangci-lint" "golangci-lint --version"
check_command "goimports" "goimports --version 2>&1 || goimports -h 2>&1 | head -1"
echo ""

# Check Node.js
echo "=== Node.js Tools ==="
check_command "node" "node --version"
check_command "npm" "npm --version"
check_command "yarn" "yarn --version"
check_command "pnpm" "pnpm --version"
echo ""

# Check Python
echo "=== Python Tools ==="
check_command "python3" "python3 --version"
check_command "pip3" "pip3 --version"
check_command "black" "black --version"
check_command "flake8" "flake8 --version"
check_command "mypy" "mypy --version"
check_command "pytest" "pytest --version"
echo ""

# Check C/C++
echo "=== C/C++ Tools ==="
check_command "gcc" "gcc --version"
check_command "g++" "g++ --version"
check_command "clang" "clang --version"
check_command "clang-format" "clang-format --version"
check_command "make" "make --version"
check_command "cmake" "cmake --version"
check_command "pkg-config" "pkg-config --version"
echo ""

# Check Development Tools
echo "=== Development Tools ==="
check_command "git" "git --version"
check_command "curl" "curl --version"
check_command "wget" "wget --version"
check_command "jq" "jq --version"
check_command "vim" "vim --version | head -1"
check_command "nano" "nano --version"
check_command "htop" "htop --version"
check_command "tree" "tree --version"
echo ""

# Check Shells
echo "=== Shells ==="
check_command "bash" "bash --version | head -1"
check_command "zsh" "zsh --version"
check_command "fish" "fish --version"
echo ""

# Check Rust tools installed via cargo
echo "=== Additional Rust Tools ==="
if command -v cargo &> /dev/null; then
    cargo install --list 2>/dev/null | grep -E "(cargo-|rustfmt|clippy)" | head -10 || echo "  (No additional tools found)"
fi
echo ""

# Check Go tools
echo "=== Additional Go Tools ==="
if [ -d "$HOME/go/bin" ]; then
    ls -1 $HOME/go/bin/ 2>/dev/null | head -10 || echo "  (No additional tools found)"
fi
echo ""

echo "=========================================="
echo "Verification Complete"
echo "=========================================="

