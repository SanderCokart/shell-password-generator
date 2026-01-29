#!/bin/bash

# Password Generator Uninstaller for Linux/macOS
# This script removes the installed password generator

set -e

# Configuration
SCRIPT_NAME="pwgen"
SYSTEM_INSTALL_DIR="/usr/local/bin"
USER_INSTALL_DIR="$HOME/.local/bin"

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


print_status "Password Generator Uninstaller for Linux/macOS"
echo

# Check for installed versions
system_installed=false
user_installed=false

if [[ -f "$SYSTEM_INSTALL_DIR/$SCRIPT_NAME" ]]; then
    system_installed=true
fi

if [[ -f "$USER_INSTALL_DIR/$SCRIPT_NAME" ]]; then
    user_installed=true
fi

# Check if anything is installed
if [[ "$system_installed" == "false" && "$user_installed" == "false" ]]; then
    print_warning "Password generator does not appear to be installed."
    print_status "Nothing to uninstall."
    exit 0
fi

# Show what will be removed
echo "The following installations will be removed:"
if [[ "$system_installed" == "true" ]]; then
    echo "  - System-wide: $SYSTEM_INSTALL_DIR/$SCRIPT_NAME"
fi
if [[ "$user_installed" == "true" ]]; then
    echo "  - User: $USER_INSTALL_DIR/$SCRIPT_NAME"
fi
echo


# Remove system-wide installation (requires sudo if not root)
if [[ "$system_installed" == "true" ]]; then
    print_status "Removing system-wide installation..."
    if [[ $EUID -eq 0 ]]; then
        # Running as root
        rm -f "$SYSTEM_INSTALL_DIR/$SCRIPT_NAME"
        print_status "System-wide installation removed."
    else
        # Need sudo
        if command -v sudo >/dev/null 2>&1; then
            sudo rm -f "$SYSTEM_INSTALL_DIR/$SCRIPT_NAME"
            print_status "System-wide installation removed."
        else
            print_error "Cannot remove system-wide installation without sudo."
            print_error "Please run this script as root or install sudo."
            exit 1
        fi
    fi
fi

# Remove user installation
if [[ "$user_installed" == "true" ]]; then
    print_status "Removing user installation..."
    rm -f "$USER_INSTALL_DIR/$SCRIPT_NAME"
    print_status "User installation removed."
fi

print_status "Uninstallation completed successfully!"
print_status "The password generator has been removed from your system."

# Clean up empty user install directory
if [[ -d "$USER_INSTALL_DIR" ]]; then
    if [[ -z "$(ls -A "$USER_INSTALL_DIR" 2>/dev/null)" ]]; then
        rmdir "$USER_INSTALL_DIR"
        print_status "Empty directory $USER_INSTALL_DIR removed."
    fi
fi