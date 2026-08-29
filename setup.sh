#!/usr/bin/env bash
# ==============================================================================
# Neovim 0.12 Full-Stack & Multi-Language Development Environment Installer
# Supports: C/C++, Rust, Web (React/TS/JS/HTML/CSS), Python, Go, CMake, Lua
# Supported Platforms: Ubuntu/Debian, Arch Linux, Fedora/RHEL, macOS (Apple Silicon & Intel)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.config/nvim"
LOCAL_BIN="${HOME}/.local/bin"
CARGO_BIN="${HOME}/.cargo/bin"
GOPATH_BIN="${HOME}/go/bin"

mkdir -p "${LOCAL_BIN}"

# Colors for terminal output
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RED="\033[31m"
RESET="\033[0m"

log_info()    { echo -e "${BLUE}[INFO]${RESET} $*"; }
log_success() { echo -e "${GREEN}[OK]${RESET}   $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${RESET} $*"; }
log_error()   { echo -e "${RED}[ERROR]${RESET} $*"; }

echo -e "${BOLD}======================================================${RESET}"
echo -e "${BOLD}  Neovim 0.12 Full-Stack & Multi-Language Installer   ${RESET}"
echo -e "${BOLD}======================================================${RESET}\n"

# ------------------------------------------------------------------------------
# 1. System Architecture, OS & PATH Detection
# ------------------------------------------------------------------------------
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "${ARCH}" in
    x86_64|amd64) ARCH_NAME="x86_64" ;;
    aarch64|arm64) ARCH_NAME="aarch64" ;;
    *) ARCH_NAME="${ARCH}" ;;
esac

# Prepend Homebrew (macOS), Go, Cargo, and Local Bin paths
if [ "${OS}" = "darwin" ]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/opt/llvm/bin:/usr/local/opt/llvm/bin:/usr/local/bin:${GOPATH_BIN}:${CARGO_BIN}:${LOCAL_BIN}:${PATH}"
else
    export PATH="${GOPATH_BIN}:${CARGO_BIN}:${LOCAL_BIN}:${PATH}"
fi

log_info "Detected OS: ${OS}, Architecture: ${ARCH_NAME}"

# ------------------------------------------------------------------------------
# 2. Check and Install System Dependencies
# ------------------------------------------------------------------------------
log_info "Checking required system dependencies..."

MISSING_DEPS=()
check_cmd() {
    local cmd="$1"
    local pkg_hint="${2:-$1}"
    if ! command -v "${cmd}" >/dev/null 2>&1 && [ ! -x "${LOCAL_BIN}/${cmd}" ] && [ ! -x "${CARGO_BIN}/${cmd}" ] && [ ! -x "${GOPATH_BIN}/${cmd}" ]; then
        MISSING_DEPS+=("${pkg_hint}")
    fi
}

check_cmd "nvim" "neovim"
check_cmd "cmake" "cmake"
check_cmd "make" "make"
check_cmd "git" "git"
check_cmd "rg" "ripgrep"
check_cmd "curl" "curl"
check_cmd "tar" "tar"
check_cmd "unzip" "unzip"

# Runtimes & Compilers
if ! command -v "gcc" >/dev/null 2>&1 && ! command -v "clang" >/dev/null 2>&1; then
    MISSING_DEPS+=("gcc / clang")
fi
if ! command -v "g++" >/dev/null 2>&1 && ! command -v "clang++" >/dev/null 2>&1; then
    MISSING_DEPS+=("g++ / clang++")
fi
check_cmd "node" "nodejs"
check_cmd "npm" "npm"
check_cmd "python3" "python3"
check_cmd "go" "golang"
check_cmd "cargo" "rust / cargo"
check_cmd "rustc" "rustc"

# Clangd check
if ! command -v "clangd" >/dev/null 2>&1 && [ ! -x "/opt/homebrew/opt/llvm/bin/clangd" ] && [ ! -x "/usr/local/opt/llvm/bin/clangd" ]; then
    MISSING_DEPS+=("clangd (LLVM)")
fi

# Clang-format check
if ! command -v "clang-format" >/dev/null 2>&1 && [ ! -x "/opt/homebrew/opt/llvm/bin/clang-format" ] && [ ! -x "/usr/local/opt/llvm/bin/clang-format" ]; then
    MISSING_DEPS+=("clang-format")
fi

# Debugger check (gdb or lldb)
if ! command -v "gdb" >/dev/null 2>&1 && ! command -v "lldb" >/dev/null 2>&1 && ! command -v "lldb-dap" >/dev/null 2>&1; then
    MISSING_DEPS+=("gdb / lldb")
fi

# Ubuntu fd-find alias handling
if ! command -v "fd" >/dev/null 2>&1; then
    if command -v "fdfind" >/dev/null 2>&1; then
        ln -sf "$(command -v fdfind)" "${LOCAL_BIN}/fd"
        log_success "Symlinked fdfind -> ${LOCAL_BIN}/fd"
    else
        MISSING_DEPS+=("fd / fd-find")
    fi
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    log_warn "Missing the following system packages: ${MISSING_DEPS[*]}"

    # Ubuntu / Debian
    if command -v apt-get >/dev/null 2>&1; then
        echo -e "\nDetected ${BOLD}Ubuntu / Debian${RESET}. Recommended install command:"
        echo -e "  sudo apt-get update && sudo apt-get install -y neovim gcc g++ clangd clang-format gdb lldb nodejs npm python3 python3-pip golang-go rustc cargo rustfmt cmake make ninja-build valgrind wl-clipboard xclip git ripgrep fd-find curl tar unzip"
        if [ "${EUID:-$(id -u)}" -eq 0 ] || sudo -n true 2>/dev/null; then
            log_info "Attempting automatic package installation via apt..."
            sudo apt-get update && sudo apt-get install -y neovim gcc g++ clangd clang-format gdb lldb nodejs npm python3 python3-pip golang-go rustc cargo rustfmt cmake make ninja-build valgrind wl-clipboard xclip git ripgrep fd-find curl tar unzip || true
            if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
                ln -sf "$(command -v fdfind)" "${LOCAL_BIN}/fd"
            fi
        fi

    # macOS Homebrew
    elif [ "${OS}" = "darwin" ]; then
        echo -e "\nDetected ${BOLD}macOS${RESET}."
        if ! command -v xcode-select >/dev/null 2>&1 || ! xcode-select -p >/dev/null 2>&1; then
            log_warn "Xcode Command Line Tools missing. Run: xcode-select --install"
        fi
        if command -v brew >/dev/null 2>&1; then
            echo -e "Recommended Homebrew install command:"
            echo -e "  brew install neovim llvm node python go rust rust-analyzer cmake make ninja ripgrep fd git curl"
            log_info "Installing missing dependencies via Homebrew..."
            brew install neovim llvm node python go rust rust-analyzer cmake make ninja ripgrep fd git curl || true
        else
            log_warn "Homebrew is not installed. Install Homebrew from https://brew.sh to easily get all toolchains."
        fi

    # Arch Linux
    elif command -v pacman >/dev/null 2>&1; then
        echo -e "\nDetected ${BOLD}Arch Linux${RESET}. Recommended install command:"
        echo -e "  sudo pacman -S --needed neovim gcc clang gdb nodejs npm python go rust cmake make ninja valgrind wl-clipboard xclip git ripgrep fd curl tar unzip"
        if [ "${EUID:-$(id -u)}" -eq 0 ] || sudo -n true 2>/dev/null; then
            log_info "Attempting automatic package installation via pacman..."
            sudo pacman -S --needed --noconfirm neovim gcc clang gdb nodejs npm python go rust cmake make ninja valgrind wl-clipboard xclip git ripgrep fd curl tar unzip || true
        fi

    # Fedora / RHEL
    elif command -v dnf >/dev/null 2>&1; then
        echo -e "\nDetected ${BOLD}Fedora / RHEL${RESET}. Recommended install command:"
        echo -e "  sudo dnf install -y neovim gcc gcc-c++ clang-tools-extra gdb lldb nodejs npm python3 golang rust cargo rust-analyzer cmake make ninja-build valgrind wl-clipboard xclip git ripgrep fd-find curl tar unzip"
        if [ "${EUID:-$(id -u)}" -eq 0 ] || sudo -n true 2>/dev/null; then
            log_info "Attempting automatic package installation via dnf..."
            sudo dnf install -y neovim gcc gcc-c++ clang-tools-extra gdb lldb nodejs npm python3 golang rust cargo rust-analyzer cmake make ninja-build valgrind wl-clipboard xclip git ripgrep fd-find curl tar unzip || true
        fi
    fi
else
    log_success "All core system packages are present."
fi

# ------------------------------------------------------------------------------
# 3. Check and Install neocmakelsp (CMake Language Server)
# ------------------------------------------------------------------------------
log_info "Checking CMake language server (neocmakelsp)..."

if command -v neocmakelsp >/dev/null 2>&1; then
    log_success "neocmakelsp is installed at $(command -v neocmakelsp)"
else
    log_info "neocmakelsp not found. Installing neocmakelsp..."
    if command -v cargo >/dev/null 2>&1; then
        log_info "Building and installing neocmakelsp via Cargo..."
        cargo install neocmakelsp || true
    fi

    # Fallback: Download prebuilt GitHub release binary
    if ! command -v neocmakelsp >/dev/null 2>&1; then
        log_info "Downloading prebuilt neocmakelsp release binary..."
        if [ "${OS}" = "darwin" ]; then
            NEOCMAKE_URL="https://github.com/neocmakelsp/neocmakelsp/releases/latest/download/neocmakelsp-universal-apple-darwin.tar.gz"
        else
            NEOCMAKE_URL="https://github.com/neocmakelsp/neocmakelsp/releases/latest/download/neocmakelsp-${ARCH_NAME}-unknown-linux-gnu.tar.gz"
        fi

        TMP_DIR="$(mktemp -d)"
        if curl -sSL "${NEOCMAKE_URL}" -o "${TMP_DIR}/neocmakelsp.tar.gz"; then
            tar -xzf "${TMP_DIR}/neocmakelsp.tar.gz" -C "${TMP_DIR}"
            install -m 755 "${TMP_DIR}/neocmakelsp" "${LOCAL_BIN}/neocmakelsp"
            rm -rf "${TMP_DIR}"
            log_success "Installed prebuilt neocmakelsp binary to ${LOCAL_BIN}/neocmakelsp"
        else
            log_warn "Failed to download prebuilt binary. If Cargo is installed, run 'cargo install neocmakelsp'."
            rm -rf "${TMP_DIR}"
        fi
    fi
fi

# ------------------------------------------------------------------------------
# 4. Check and Install rust-analyzer (Rust Language Server)
# ------------------------------------------------------------------------------
log_info "Checking Rust language server (rust-analyzer)..."

if command -v rust-analyzer >/dev/null 2>&1 || [ -x "${LOCAL_BIN}/rust-analyzer" ]; then
    log_success "rust-analyzer is installed"
else
    log_info "rust-analyzer not found. Downloading latest release..."
    if [ "${OS}" = "darwin" ]; then
        if [ "${ARCH_NAME}" = "aarch64" ]; then
            RA_URL="https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-aarch64-apple-darwin.gz"
        else
            RA_URL="https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-apple-darwin.gz"
        fi
    else
        if [ "${ARCH_NAME}" = "aarch64" ]; then
            RA_URL="https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-aarch64-unknown-linux-gnu.gz"
        else
            RA_URL="https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz"
        fi
    fi

    if curl -sSL "${RA_URL}" | gzip -d > "${LOCAL_BIN}/rust-analyzer"; then
        chmod +x "${LOCAL_BIN}/rust-analyzer"
        log_success "Installed rust-analyzer to ${LOCAL_BIN}/rust-analyzer"
    else
        log_warn "Failed to download rust-analyzer. Install via rustup or package manager."
    fi
fi

# ------------------------------------------------------------------------------
# 5. Check and Install marksman (Markdown Language Server)
# ------------------------------------------------------------------------------
log_info "Checking Markdown language server (marksman)..."

if command -v marksman >/dev/null 2>&1 || [ -x "${LOCAL_BIN}/marksman" ]; then
    log_success "marksman is installed"
else
    log_info "marksman not found. Downloading latest prebuilt binary..."
    if [ "${OS}" = "darwin" ]; then
        if [ "${ARCH_NAME}" = "aarch64" ]; then
            MM_URL="https://github.com/artempyanykh/marksman/releases/latest/download/marksman-macos-arm64"
        else
            MM_URL="https://github.com/artempyanykh/marksman/releases/latest/download/marksman-macos-x64"
        fi
    else
        if [ "${ARCH_NAME}" = "aarch64" ]; then
            MM_URL="https://github.com/artempyanykh/marksman/releases/latest/download/marksman-linux-arm64"
        else
            MM_URL="https://github.com/artempyanykh/marksman/releases/latest/download/marksman-linux-x64"
        fi
    fi

    if curl -sSL "${MM_URL}" -o "${LOCAL_BIN}/marksman"; then
        chmod +x "${LOCAL_BIN}/marksman"
        log_success "Installed marksman to ${LOCAL_BIN}/marksman"
    else
        log_warn "Failed to download marksman. Install marksman manually if Markdown LSP is needed."
    fi
fi

# ------------------------------------------------------------------------------
# 6. Link Configuration to ~/.config/nvim
# ------------------------------------------------------------------------------
log_info "Configuring ~/.config/nvim symlink..."

if [ -e "${TARGET_DIR}" ]; then
    if [ -L "${TARGET_DIR}" ] && [ "$(readlink -f "${TARGET_DIR}")" = "${SCRIPT_DIR}" ]; then
        log_success "${TARGET_DIR} is already linked to ${SCRIPT_DIR}"
    else
        BACKUP_DIR="${HOME}/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        log_warn "Existing ~/.config/nvim directory found. Backing up to ${BACKUP_DIR}..."
        mv "${TARGET_DIR}" "${BACKUP_DIR}"
        ln -s "${SCRIPT_DIR}" "${TARGET_DIR}"
        log_success "Symlinked ${SCRIPT_DIR} -> ${TARGET_DIR}"
    fi
else
    mkdir -p "${HOME}/.config"
    ln -s "${SCRIPT_DIR}" "${TARGET_DIR}"
    log_success "Symlinked ${SCRIPT_DIR} -> ${TARGET_DIR}"
fi

# ------------------------------------------------------------------------------
# 6. Bootstrap and Sync Neovim Plugins via lazy.nvim
# ------------------------------------------------------------------------------
log_info "Syncing Neovim plugins via lazy.nvim..."
nvim --headless "+Lazy! sync" "+qa" || true
log_success "Neovim plugins synchronized."

# ------------------------------------------------------------------------------
# 7. Install Treesitter Parsers
# ------------------------------------------------------------------------------
log_info "Compiling Treesitter parsers (C/C++, Rust, Web/React, Python, Go, Lua, etc.)..."
nvim --headless -c "lua require('nvim-treesitter.install').install({'c','cpp','rust','ron','cmake','make','ninja','lua','vim','vimdoc','bash','json','json5','yaml','toml','markdown','markdown_inline','dockerfile','javascript','typescript','tsx','html','css','scss','python','go','gomod','gowork','gosum'})" -c "sleep 8" -c "qa" || true
log_success "Treesitter parsers compiled and installed."

# ------------------------------------------------------------------------------
# 8. Final Health & Diagnostics Check
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}======================================================${RESET}"
echo -e "${BOLD}               Setup Verification Summary             ${RESET}"
echo -e "${BOLD}======================================================${RESET}"

report_tool() {
    local name="$1"
    local cmd="$2"
    if command -v "${cmd}" >/dev/null 2>&1; then
        echo -e "  [${GREEN}✓${RESET}] ${name}: $(command -v "${cmd}")"
    else
        echo -e "  [${YELLOW}?${RESET}] ${name}: not found in PATH"
    fi
}

echo -e "${BOLD}--- Core & Editors ---${RESET}"
report_tool "Neovim" "nvim"
report_tool "Git" "git"
report_tool "Ripgrep" "rg"

echo -e "\n${BOLD}--- C / C++ & CMake ---${RESET}"
report_tool "Clangd (C/C++ LSP)" "clangd"
report_tool "Clang-Format" "clang-format"
if command -v gcc >/dev/null 2>&1; then report_tool "GCC (C Compiler)" "gcc"; else report_tool "Clang (C Compiler)" "clang"; fi
if command -v g++ >/dev/null 2>&1; then report_tool "G++ (C++ Compiler)" "g++"; else report_tool "Clang++ (C++ Compiler)" "clang++"; fi
if command -v gdb >/dev/null 2>&1; then report_tool "GDB (Debugger)" "gdb"; fi
if command -v lldb >/dev/null 2>&1 || command -v lldb-dap >/dev/null 2>&1; then
    if command -v lldb-dap >/dev/null 2>&1; then report_tool "LLDB DAP" "lldb-dap"; else report_tool "LLDB" "lldb"; fi
fi
report_tool "CMake" "cmake"
report_tool "Neocmakelsp (CMake LSP)" "neocmakelsp"
report_tool "Make" "make"

echo -e "\n${BOLD}--- Rust Development ---${RESET}"
report_tool "Rust Compiler (rustc)" "rustc"
report_tool "Cargo Package Manager" "cargo"
report_tool "Rust-Analyzer (LSP)" "rust-analyzer"
report_tool "Rustfmt Formatter" "rustfmt"

echo -e "\n${BOLD}--- Web Development (React / TS / JS) ---${RESET}"
report_tool "Node.js Runtime" "node"
report_tool "NPM Package Manager" "npm"
if command -v pnpm >/dev/null 2>&1; then report_tool "PNPM" "pnpm"; fi
if command -v bun >/dev/null 2>&1; then report_tool "Bun" "bun"; fi
report_tool "TypeScript Compiler" "tsc"
report_tool "Prettier Formatter" "prettier"

echo -e "\n${BOLD}--- Python Development ---${RESET}"
report_tool "Python Runtime" "python3"
report_tool "Pip" "pip"
if command -v ruff >/dev/null 2>&1; then report_tool "Ruff Linter/Formatter" "ruff"; fi
if command -v pytest >/dev/null 2>&1; then report_tool "Pytest" "pytest"; fi

echo -e "\n${BOLD}--- Go (Golang) Development ---${RESET}"
if command -v go >/dev/null 2>&1; then report_tool "Go Toolchain" "go"; fi
report_tool "Gopls (Go LSP)" "gopls"
if command -v dlv >/dev/null 2>&1; then report_tool "Delve Debugger" "dlv"; fi
if command -v gofumpt >/dev/null 2>&1; then report_tool "Gofumpt Formatter" "gofumpt"; fi
if command -v goimports >/dev/null 2>&1; then report_tool "Goimports Formatter" "goimports"; fi

echo -e "\n${BOLD}--- Lua & Tooling ---${RESET}"
if command -v stylua >/dev/null 2>&1 || [ -x "${LOCAL_BIN}/stylua" ]; then report_tool "StyLua Formatter" "stylua"; fi

echo -e "\n${BOLD}--- Markdown & Documentation ---${RESET}"
report_tool "Marksman (Markdown LSP)" "marksman"
report_tool "Prettier (Markdown Formatter)" "prettier"

echo -e "\n${BOLD}Setup completed successfully!${RESET}"
echo -e "Start editing with:"
echo -e "  ${GREEN}nvim${RESET}\n"
