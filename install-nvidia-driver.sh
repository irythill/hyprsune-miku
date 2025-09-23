#!/bin/bash

# 🎮 NVIDIA Driver Installer for Hyprsune Miku
# Safe installation script for NVIDIA GT 710 and other GPUs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art
echo -e "${CYAN}"
cat << "EOF"
╔════════════════════════════════════════════════════╗
║  🎮 NVIDIA Driver Installer - Safe & Secure 🎮    ║
║  Optimized for GT 710 and Hyprland                ║
╚════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${BLUE}🎮 NVIDIA Driver Installer for Hyprsune Miku${NC}"
echo -e "${YELLOW}This script will safely install NVIDIA drivers for your GT 710${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ This script should not be run as root${NC}"
   exit 1
fi

# Check if we're in the right directory
if [[ ! -f "hypr/hyprland/nvidia.conf" ]]; then
    echo -e "${RED}❌ Please run this script from the hyprsune-miku directory${NC}"
    exit 1
fi

# Function to ask yes/no questions
ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}"
    
    while true; do
        if [[ "$default" == "y" ]]; then
            read -p "$prompt [Y/n]: " yn
            yn=${yn:-y}
        else
            read -p "$prompt [y/N]: " yn
            yn=${yn:-n}
        fi
        
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Function to create backup
create_backup() {
    echo -e "${BLUE}💾 Creating system backup...${NC}"
    
    # Create backup directory
    BACKUP_DIR="$HOME/.config/hyprsune-miku-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup current X11 configs
    if [[ -d "/etc/X11/xorg.conf.d" ]]; then
        sudo cp -r /etc/X11/xorg.conf.d "$BACKUP_DIR/" 2>/dev/null || true
    fi
    
    # Backup current modprobe configs
    if [[ -f "/etc/modprobe.d/nouveau.conf" ]]; then
        sudo cp /etc/modprobe.d/nouveau.conf "$BACKUP_DIR/" 2>/dev/null || true
    fi
    
    # Backup current kernel parameters
    if [[ -f "/etc/default/grub" ]]; then
        sudo cp /etc/default/grub "$BACKUP_DIR/" 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✅ Backup created at: $BACKUP_DIR${NC}"
    echo "$BACKUP_DIR" > /tmp/hyprsune_backup_path
}

# Function to detect GPU
detect_gpu() {
    echo -e "${BLUE}🔍 Detecting GPU...${NC}"
    
    if lspci | grep -i nvidia | grep -q "GT 710"; then
        echo -e "${GREEN}✅ NVIDIA GT 710 detected${NC}"
        GPU_MODEL="GT 710"
        return 0
    elif lspci | grep -i nvidia; then
        echo -e "${GREEN}✅ NVIDIA GPU detected${NC}"
        GPU_MODEL="NVIDIA"
        return 0
    else
        echo -e "${RED}❌ No NVIDIA GPU detected${NC}"
        return 1
    fi
}

# Function to check current driver
check_current_driver() {
    echo -e "${BLUE}🔍 Checking current driver...${NC}"
    
    if command -v nvidia-smi >/dev/null 2>&1; then
        echo -e "${GREEN}✅ NVIDIA proprietary driver already installed${NC}"
        nvidia-smi --query-gpu=name,driver_version --format=csv,noheader,nounits
        return 0
    elif lsmod | grep -q nouveau; then
        echo -e "${YELLOW}⚠️  Nouveau driver currently active${NC}"
        return 1
    else
        echo -e "${YELLOW}⚠️  No NVIDIA driver detected${NC}"
        return 1
    fi
}

# Function to install NVIDIA driver
install_nvidia_driver() {
    echo -e "${BLUE}📦 Installing NVIDIA driver...${NC}"
    
    # Update package database
    echo -e "${YELLOW}🔄 Updating package database...${NC}"
    sudo pacman -Sy
    
    # Install NVIDIA driver and utilities
    echo -e "${YELLOW}📦 Installing NVIDIA packages...${NC}"
    sudo pacman -S --noconfirm nvidia-dkms nvidia-utils nvidia-settings
    
    # Install additional packages for Wayland
    echo -e "${YELLOW}📦 Installing Wayland support packages...${NC}"
    sudo pacman -S --noconfirm libva-nvidia-driver
    
    echo -e "${GREEN}✅ NVIDIA driver installed successfully${NC}"
}

# Function to configure system
configure_system() {
    echo -e "${BLUE}⚙️  Configuring system...${NC}"
    
    # Blacklist nouveau
    echo -e "${YELLOW}🚫 Blacklisting nouveau driver...${NC}"
    sudo tee /etc/modprobe.d/nouveau.conf > /dev/null << EOF
blacklist nouveau
options nouveau modeset=0
EOF
    
    # Update initramfs
    echo -e "${YELLOW}🔄 Updating initramfs...${NC}"
    sudo mkinitcpio -P
    
    # Configure kernel parameters
    echo -e "${YELLOW}⚙️  Configuring kernel parameters...${NC}"
    
    # Check if nvidia-drm.modeset=1 is already in GRUB_CMDLINE_LINUX_DEFAULT
    if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&nvidia-drm.modeset=1 /' /etc/default/grub
        echo -e "${GREEN}✅ Added nvidia-drm.modeset=1 to kernel parameters${NC}"
    else
        echo -e "${GREEN}✅ nvidia-drm.modeset=1 already configured${NC}"
    fi
    
    # Update GRUB
    echo -e "${YELLOW}🔄 Updating GRUB configuration...${NC}"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    
    echo -e "${GREEN}✅ System configuration completed${NC}"
}

# Function to setup Hyprland config
setup_hyprland_config() {
    echo -e "${BLUE}🎨 Setting up Hyprland configuration...${NC}"
    
    # Ensure NVIDIA config is properly linked
    if [[ -f "hypr/hyprland/nvidia.conf" ]]; then
        echo -e "${GREEN}✅ NVIDIA configuration file found${NC}"
        
        # Check if main config includes NVIDIA config
        if grep -q "source=hyprland/nvidia.conf" hypr/hyprland.conf; then
            echo -e "${GREEN}✅ NVIDIA config already included in main config${NC}"
        else
            echo -e "${YELLOW}⚠️  Adding NVIDIA config to main config...${NC}"
            echo "source=hyprland/nvidia.conf" >> hypr/hyprland.conf
            echo -e "${GREEN}✅ NVIDIA config added to main config${NC}"
        fi
    else
        echo -e "${RED}❌ NVIDIA configuration file not found${NC}"
        return 1
    fi
}

# Function to create recovery script
create_recovery_script() {
    echo -e "${BLUE}🛡️  Creating recovery script...${NC}"
    
    cat > recover-from-nouveau.sh << 'EOF'
#!/bin/bash
# Recovery script to switch back to nouveau if needed

echo "🔄 Switching back to nouveau driver..."

# Remove NVIDIA blacklist
sudo rm -f /etc/modprobe.d/nouveau.conf

# Remove NVIDIA packages
sudo pacman -Rns nvidia-dkms nvidia-utils nvidia-settings libva-nvidia-driver

# Remove nvidia-drm.modeset from kernel parameters
sudo sed -i 's/ nvidia-drm.modeset=1//' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Update initramfs
sudo mkinitcpio -P

echo "✅ Recovery completed. Please reboot to use nouveau driver."
EOF
    
    chmod +x recover-from-nouveau.sh
    echo -e "${GREEN}✅ Recovery script created: recover-from-nouveau.sh${NC}"
}

# Main installation process
main() {
    echo -e "${BLUE}🚀 Starting NVIDIA driver installation...${NC}"
    echo ""
    
    # Detect GPU
    if ! detect_gpu; then
        echo -e "${RED}❌ NVIDIA GPU not detected. Exiting...${NC}"
        exit 1
    fi
    
    # Check current driver
    if check_current_driver; then
        echo -e "${GREEN}✅ NVIDIA driver already installed and working${NC}"
        if ask_yes_no "Do you want to reinstall anyway?" "n"; then
            echo -e "${YELLOW}⚠️  Proceeding with reinstallation...${NC}"
        else
            echo -e "${GREEN}✅ Installation cancelled${NC}"
            exit 0
        fi
    fi
    
    # Show installation summary
    echo -e "${BLUE}📋 Installation Summary:${NC}"
    echo -e "  GPU: $GPU_MODEL"
    echo -e "  Driver: NVIDIA DKMS"
    echo -e "  Wayland: Supported"
    echo -e "  Hyprland: Optimized"
    echo ""
    
    if ! ask_yes_no "Do you want to proceed with the installation?" "y"; then
        echo -e "${YELLOW}Installation cancelled${NC}"
        exit 0
    fi
    
    # Create backup
    create_backup
    
    # Install driver
    install_nvidia_driver
    
    # Configure system
    configure_system
    
    # Setup Hyprland config
    setup_hyprland_config
    
    # Create recovery script
    create_recovery_script
    
    echo ""
    echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Next steps:${NC}"
    echo -e "  1. ${BLUE}Reboot your system${NC}"
    echo -e "  2. ${BLUE}Run 'nvidia-smi' to verify installation${NC}"
    echo -e "  3. ${BLUE}Test Hyprland with the new driver${NC}"
    echo ""
    echo -e "${YELLOW}🛡️  Recovery:${NC}"
    echo -e "  If you need to switch back to nouveau, run: ${BLUE}./recover-from-nouveau.sh${NC}"
    echo ""
    echo -e "${GREEN}🎵 Enjoy your optimized Hyprsune Miku setup! 🎵${NC}"
}

# Run main function
main "$@"
