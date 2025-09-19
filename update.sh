#!/bin/bash

# Hatsune Miku Dotfiles Update Script
# Preserves custom configurations while updating from end-4/dots-hyprland

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
END4_REPO="https://github.com/end-4/dots-hyprland.git"
TEMP_DIR="/tmp/end-4-update-$$"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"

# Files to preserve (our customizations)
PRESERVE_FILES=(
    ".config/quickshell/ii/modules/common/Appearance.qml"
    ".config/quickshell/ii/modules/lock/LockSurface.qml"
    ".config/fish/functions/fish_greeting.fish"
    ".config/fastfetch/hatsune_ascii.txt"
    ".config/fastfetch/hatsune_ascii_compact.txt"
    ".config/hypr/hyprland/keybinds.conf"
    ".local/bin/quickshell-lock"
)

# Directories to preserve
PRESERVE_DIRS=(
    ".config/quickshell/ii/wallpapers"
    ".config/systemd/user"
    ".config/kitty"
)

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_header() {
    echo -e "\n${PURPLE}=== $1 ===${NC}"
}

# Function to backup current config
backup_config() {
    log_header "Creating Backup"
    
    mkdir -p "$BACKUP_DIR"
    
    # Backup entire config
    cp -r "$HOME/.config" "$BACKUP_DIR/"
    cp -r "$HOME/.local/bin" "$BACKUP_DIR/" 2>/dev/null || true
    
    log_success "Backup created at: $BACKUP_DIR"
}

# Function to clone end-4 repository
clone_end4() {
    log_header "Downloading end-4 Configuration"
    
    rm -rf "$TEMP_DIR"
    git clone "$END4_REPO" "$TEMP_DIR"
    
    log_success "end-4 repository cloned to: $TEMP_DIR"
}

# Function to preserve custom files
preserve_custom_files() {
    log_header "Preserving Custom Files"
    
    for file in "${PRESERVE_FILES[@]}"; do
        local home_file="$HOME/$file"
        local temp_file="$TEMP_DIR/$file"
        
        if [[ -f "$home_file" ]]; then
            # Create directory structure in temp
            mkdir -p "$(dirname "$temp_file")"
            # Copy our custom file to temp (overwrite end-4's version)
            cp "$home_file" "$temp_file"
            log_info "Preserved: $file"
        fi
    done
    
    # Preserve directories
    for dir in "${PRESERVE_DIRS[@]}"; do
        local home_dir="$HOME/$dir"
        local temp_dir="$TEMP_DIR/$dir"
        
        if [[ -d "$home_dir" ]]; then
            # Remove end-4's version and copy ours
            rm -rf "$temp_dir" 2>/dev/null || true
            mkdir -p "$(dirname "$temp_dir")"
            cp -r "$home_dir" "$temp_dir"
            log_info "Preserved directory: $dir"
        fi
    done
}

# Function to install updated configuration
install_config() {
    log_header "Installing Updated Configuration"
    
    # Install from temp directory
    cd "$TEMP_DIR"
    
    # Run end-4's install script
    if [[ -f "install.sh" ]]; then
        log_info "Running end-4 install script..."
        chmod +x install.sh
        ./install.sh
    else
        log_error "end-4 install.sh not found!"
        return 1
    fi
}

# Function to restore custom files
restore_custom_files() {
    log_header "Restoring Custom Files"
    
    for file in "${PRESERVE_FILES[@]}"; do
        local home_file="$HOME/$file"
        local backup_file="$BACKUP_DIR/$file"
        
        if [[ -f "$backup_file" ]]; then
            mkdir -p "$(dirname "$home_file")"
            cp "$backup_file" "$home_file"
            log_info "Restored: $file"
        fi
    done
    
    # Restore directories
    for dir in "${PRESERVE_DIRS[@]}"; do
        local home_dir="$HOME/$dir"
        local backup_dir="$BACKUP_DIR/$dir"
        
        if [[ -d "$backup_dir" ]]; then
            rm -rf "$home_dir" 2>/dev/null || true
            mkdir -p "$(dirname "$home_dir")"
            cp -r "$backup_dir" "$home_dir"
            log_info "Restored directory: $dir"
        fi
    done
    
    # Remove auto-generated colors to ensure our custom colors are used
    if [[ -d "$HOME/.local/state/quickshell/user/generated" ]]; then
        rm -rf "$HOME/.local/state/quickshell/user/generated"
        log_info "Removed auto-generated colors to preserve Hatsune Miku theme"
    fi
}

# Function to clean up
cleanup() {
    log_header "Cleanup"
    
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
        log_info "Cleaned up temporary files"
    fi
}

# Function to show help
show_help() {
    echo "Hatsune Miku Dotfiles Update Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -b, --backup   Only create backup, don't update"
    echo "  -r, --restore  Restore from latest backup"
    echo ""
    echo "This script:"
    echo "  1. Creates a backup of your current configuration"
    echo "  2. Downloads the latest end-4/dots-hyprland configuration"
    echo "  3. Preserves your Hatsune Miku customizations"
    echo "  4. Installs the updated configuration"
    echo "  5. Restores your custom files"
    echo ""
    echo "Preserved files:"
    for file in "${PRESERVE_FILES[@]}"; do
        echo "  - $file"
    done
    echo ""
    echo "Preserved directories:"
    for dir in "${PRESERVE_DIRS[@]}"; do
        echo "  - $dir"
    done
}

# Main function
main() {
    local backup_only=false
    local restore_only=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -b|--backup)
                backup_only=true
                shift
                ;;
            -r|--restore)
                restore_only=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Show banner
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════╗"
    echo "║  🎵 Hatsune Miku Dotfiles Update Script 🎵 ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [[ "$restore_only" == true ]]; then
        # Find latest backup
        local latest_backup=$(ls -td "$HOME/.config-backup-"* 2>/dev/null | head -1)
        if [[ -z "$latest_backup" ]]; then
            log_error "No backup found!"
            exit 1
        fi
        
        log_info "Restoring from: $latest_backup"
        BACKUP_DIR="$latest_backup"
        restore_custom_files
        log_success "Restoration completed!"
        exit 0
    fi
    
    if [[ "$backup_only" == true ]]; then
        backup_config
        log_success "Backup completed!"
        exit 0
    fi
    
    # Full update process
    log_info "Starting Hatsune Miku dotfiles update..."
    
    # Step 1: Backup
    backup_config
    
    # Step 2: Clone end-4
    clone_end4
    
    # Step 3: Preserve custom files in temp
    preserve_custom_files
    
    # Step 4: Install updated config
    install_config
    
    # Step 5: Restore custom files
    restore_custom_files
    
    # Step 6: Cleanup
    cleanup
    
    log_header "Update Complete!"
    log_success "🎵 Hatsune Miku dotfiles updated successfully! 🎵"
    log_info "Your customizations have been preserved:"
    for file in "${PRESERVE_FILES[@]}"; do
        echo "  ✅ $file"
    done
    for dir in "${PRESERVE_DIRS[@]}"; do
        echo "  ✅ $dir"
    done
    echo ""
    log_info "Backup available at: $BACKUP_DIR"
    log_info "You may need to restart Hyprland or log out/in to see changes."
}

# Trap to ensure cleanup on exit
trap cleanup EXIT

# Run main function
main "$@"
