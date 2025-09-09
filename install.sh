#!/bin/bash
# Athena07 Banner Installer
# Created by: Subramaniam Bhavimane

# Colors for output
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

BANNER_URL="https://raw.githubusercontent.com/Subramaniam004/athena07-banner/main/athena07-banner.sh"
INSTALL_DIR="$HOME"
BANNER_SCRIPT="$INSTALL_DIR/athena07-banner.sh"

# Function to display messages
function info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

function success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

function warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

function error() {
    echo -e "${RED}[ERROR]${RESET} $1"
    exit 1
}

clear
echo -e "${GREEN}"
echo "======================================"
echo " Athena07 Banner Installation Script "
echo "======================================"
echo -e "${RESET}"

# Check if wget or curl is available
if command -v wget &> /dev/null; then
    DOWNLOADER="wget -q -O"
elif command -v curl &> /dev/null; then
    DOWNLOADER="curl -sSL -o"
else
    error "Neither wget nor curl is installed. Please install one and try again."
fi

# Download banner script
info "Downloading Athena07 banner..."
$DOWNLOADER "$BANNER_SCRIPT" "$BANNER_URL" || error "Failed to download banner script."

# Make it executable
chmod +x "$BANNER_SCRIPT"
success "Banner downloaded and made executable at: $BANNER_SCRIPT"

# Prompt user for setup option
echo
echo "Choose where you want to display the banner:"
echo "1) Show every time you open a terminal (local only)"
echo "2) Show only on SSH login (for all users)"
echo "3) Both terminal and SSH login"
read -p "Enter option [1-3]: " choice

# Add to .bashrc for terminal sessions
add_to_bashrc() {
    if ! grep -Fxq "$BANNER_SCRIPT" "$HOME/.bashrc"; then
        echo "$BANNER_SCRIPT" >> "$HOME/.bashrc"
        success "Banner added to ~/.bashrc"
    else
        warning "Banner already exists in ~/.bashrc"
    fi
}

# Add to /etc/profile for SSH
add_to_ssh() {
    if [ "$(id -u)" -ne 0 ]; then
        warning "You must run this script as root (sudo) to enable SSH login banner."
        return
    fi

    if ! grep -Fxq "$BANNER_SCRIPT" "/etc/profile"; then
        echo "$BANNER_SCRIPT" >> "/etc/profile"
        success "Banner added to /etc/profile for SSH login."
    else
        warning "Banner already exists in /etc/profile"
    fi
}

# Apply choice
case "$choice" in
    1) add_to_bashrc ;;
    2) add_to_ssh ;;
    3) add_to_bashrc; add_to_ssh ;;
    *) warning "Invalid option selected. Skipping auto-setup." ;;
esac

echo
success "Installation complete!"
echo
info "To test it now, run:"
echo "$BANNER_SCRIPT"
