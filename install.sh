#!/bin/bash

# Password Generator Installer for Linux/macOS
# This script downloads and installs the password generator shell script

set -e

# Configuration
REPO_URL="https://raw.githubusercontent.com/SanderCokart/shell-password-generator/main/script.sh"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="pwgen"
TEMP_FILE="/tmp/password-generator-script.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}


# Check if running as root/sudo
if [[ $EUID -eq 0 ]]; then
    print_warning "Running as root. This will install system-wide."
else
    print_status "Installing for current user only."
    INSTALL_DIR="$HOME/.local/bin"
    # Create directory if it doesn't exist
    mkdir -p "$INSTALL_DIR"
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        print_warning "$INSTALL_DIR is not in your PATH."
        print_status "Add the following line to your ~/.bashrc or ~/.zshrc:"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\""
    fi
fi

# Check if curl or wget is available
if command -v curl >/dev/null 2>&1; then
    DOWNLOADER="curl -fsSL"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOADER="wget -q -O -"
else
    print_error "Neither curl nor wget is available. Please install one of them."
    exit 1
fi

print_status "Downloading password generator script..."

# Download the script
if ! $DOWNLOADER "$REPO_URL" > "$TEMP_FILE"; then
    print_error "Failed to download the script from $REPO_URL"
    exit 1
fi

# Verify the downloaded script
if [[ ! -s "$TEMP_FILE" ]]; then
    print_error "Downloaded file is empty"
    rm -f "$TEMP_FILE"
    exit 1
fi

# Check if script is already installed
if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
    print_status "Overwriting existing installation..."
fi

# Install the script
print_status "Installing to $INSTALL_DIR/$SCRIPT_NAME..."
if ! mv "$TEMP_FILE" "$INSTALL_DIR/$SCRIPT_NAME"; then
    print_error "Failed to install the script"
    rm -f "$TEMP_FILE"
    exit 1
fi

# Make it executable
if ! chmod +x "$INSTALL_DIR/$SCRIPT_NAME"; then
    print_error "Failed to make the script executable"
    exit 1
fi

print_status "Installation completed successfully!"
print_status "You can now use the password generator with: $SCRIPT_NAME"
print_status "Run '$SCRIPT_NAME --help' for usage information."

# Test the installation
if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
    print_status "Testing installation..."
    if "$SCRIPT_NAME" --help >/dev/null 2>&1; then
        print_status "Installation test passed!"
    else
        print_warning "Installation test failed, but script was installed."
    fi
else
    print_warning "Script installed but not found in PATH. Make sure $INSTALL_DIR is in your PATH."
fi