#!/bin/bash

# Hatsune Miku Theme Application Script
# Ensures the Hatsune Miku theme is properly applied

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

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

# Show banner
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════╗"
echo "║  🎵 Applying Hatsune Miku Theme 🎵 ║"
echo "╚════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to apply Hatsune Miku theme
apply_miku_theme() {
    log_header "Applying Hatsune Miku Theme"
    
    # Remove auto-generated colors
    if [[ -d "$HOME/.local/state/quickshell/user/generated" ]]; then
        rm -rf "$HOME/.local/state/quickshell/user/generated"
        log_info "Removed auto-generated colors"
    fi
    
    # Restart Quickshell to apply theme
    if systemctl --user is-active --quiet quickshell.service; then
        log_info "Restarting Quickshell service..."
        systemctl --user restart quickshell.service
        sleep 3
        
        if systemctl --user is-active --quiet quickshell.service; then
            log_success "Quickshell restarted successfully"
        else
            log_error "Failed to restart Quickshell service"
            return 1
        fi
    else
        log_warning "Quickshell service is not running"
        log_info "Starting Quickshell service..."
        systemctl --user start quickshell.service
        sleep 3
        
        if systemctl --user is-active --quiet quickshell.service; then
            log_success "Quickshell started successfully"
        else
            log_error "Failed to start Quickshell service"
            return 1
        fi
    fi
    
    # Verify theme files exist
    local theme_files=(
        "$HOME/.config/quickshell/ii/modules/common/Appearance.qml"
        "$HOME/.config/quickshell/ii/modules/lock/LockSurface.qml"
    )
    
    for file in "${theme_files[@]}"; do
        if [[ -f "$file" ]]; then
            log_success "Theme file exists: $(basename "$file")"
        else
            log_warning "Theme file missing: $(basename "$file")"
        fi
    done
}

# Function to show help
show_help() {
    echo "Hatsune Miku Theme Application Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -c, --check    Check if theme is properly applied"
    echo ""
    echo "This script:"
    echo "  1. Removes auto-generated color files"
    echo "  2. Restarts Quickshell service"
    echo "  3. Verifies theme files are present"
    echo ""
    echo "Use this script whenever you notice the theme colors"
    echo "are not being applied correctly."
}

# Function to check theme status
check_theme() {
    log_header "Checking Theme Status"
    
    # Check if auto-generated colors exist
    if [[ -d "$HOME/.local/state/quickshell/user/generated" ]]; then
        log_warning "Auto-generated colors found - this may override Hatsune Miku theme"
        echo "  Location: $HOME/.local/state/quickshell/user/generated"
    else
        log_success "No auto-generated colors found"
    fi
    
    # Check Quickshell service status
    if systemctl --user is-active --quiet quickshell.service; then
        log_success "Quickshell service is running"
    else
        log_warning "Quickshell service is not running"
    fi
    
    # Check theme files
    local theme_files=(
        "$HOME/.config/quickshell/ii/modules/common/Appearance.qml"
        "$HOME/.config/quickshell/ii/modules/lock/LockSurface.qml"
    )
    
    for file in "${theme_files[@]}"; do
        if [[ -f "$file" ]]; then
            log_success "Theme file exists: $(basename "$file")"
        else
            log_error "Theme file missing: $(basename "$file")"
        fi
    done
}

# Main function
main() {
    local check_only=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -c|--check)
                check_only=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    if [[ "$check_only" == true ]]; then
        check_theme
    else
        apply_miku_theme
        log_header "Theme Application Complete!"
        log_success "🎵 Hatsune Miku theme should now be active! 🎵"
        log_info "If colors still don't appear correctly, try logging out and back in."
    fi
}

# Run main function
main "$@"
