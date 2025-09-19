#!/bin/bash

# Script para configurar teclado BR (Brasil) no Hyprland + Quickshell

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
echo "║  🇧🇷 Configurando Teclado BR (Brasil) 🇧🇷 ║"
echo "╚════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to install fcitx5
install_fcitx5() {
    log_header "Instalando fcitx5"
    
    log_info "Instalando pacotes necessários..."
    sudo pacman -S --noconfirm fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-chinese-addons fcitx5-hangul
    
    log_success "fcitx5 instalado com sucesso!"
}

# Function to configure fcitx5 for BR
configure_fcitx5() {
    log_header "Configurando fcitx5 para BR"
    
    # Create fcitx5 config directory
    mkdir -p ~/.config/fcitx5/conf
    
    # Create fcitx5 config file
    cat > ~/.config/fcitx5/config << 'EOF'
[General]
Name=Default
Name[ca]=Per defecte
Name[da]=Standard
Name[de]=Standard
Name[he]=ברירת מחדל
Name[ko]=기본값
Name[lt]=Numatytasis
Name[pl]=Domyślny
Name[ru]=По умолчанию
Name[th]=ค่าเริ่มต้น
Name[tr]=Varsayılan
Name[uk]=Типово
Name[vi]=Mặc định
Name[zh_CN]=默认
Name[zh_TW]=預設

[Hotkey]
TriggerKeys=Control+space
AltTriggerKeys=
SwitchLastInputMethodKeys=
SwitchLastInputMethodKeysAlt=
EnumerateWithTriggerKeys=True
EnumerateSkipFirst=True
EnumerateGroupForwardKeys=
EnumerateGroupForwardKeysAlt=
EnumerateForwardKeys=
EnumerateForwardKeysAlt=
EnumerateBackwardKeys=
EnumerateBackwardKeysAlt=
ActivateKeys=
DeactivateKeys=
PrevPage=Up
NextPage=Down
PrevCandidate=Shift+Tab
NextCandidate=Tab
TogglePreedit=Control+Alt+P
TogglePreeditAlt=
ToggleInputMethod=Control+space
ToggleInputMethodAlt=
ToggleQuickPhrase=Control+Alt+U
ToggleQuickPhraseAlt=
ToggleUnicode=Control+Alt+Shift+U
ToggleUnicodeAlt=
ToggleTable=Control+Alt+E
ToggleTableAlt=
ToggleDict=Control+Alt+G
ToggleDictAlt=
TogglePinyin=Control+Alt+P
TogglePinyinAlt=
ToggleShuangpin=Control+Alt+S
ToggleShuangpinAlt=
ToggleCloudPinyin=Control+Alt+C
ToggleCloudPinyinAlt=
ToggleSpecialPhrase=Control+Alt+Z
ToggleSpecialPhraseAlt=
ToggleEmoji=Control+Alt+E
ToggleEmojiAlt=
ToggleClipboard=Control+Alt+V
ToggleClipboardAlt=
ToggleMacro=Control+Alt+B
ToggleMacroAlt=
ToggleLayout=Control+Alt+L
ToggleLayoutAlt=
ToggleAsciiMode=Control+Alt+Shift+space
ToggleAsciiModeAlt=
ToggleAsciiPunc=Control+Alt+Comma
ToggleAsciiPuncAlt=
ToggleFullWidth=Control+Alt+Period
ToggleFullWidthAlt=
ToggleInputMethodMenu=Control+Alt+Shift+M
ToggleInputMethodMenuAlt=
ReloadConfig=Control+Alt+R
ReloadConfigAlt=
Exit=Control+Alt+Q
ExitAlt=
EOF

    # Create input method config
    cat > ~/.config/fcitx5/conf/inputmethod.conf << 'EOF'
[Groups/0]
Name=Default
Name[ca]=Per defecte
Name[da]=Standard
Name[de]=Standard
Name[he]=ברירת מחדל
Name[ko]=기본값
Name[lt]=Numatytasis
Name[pl]=Domyślny
Name[ru]=По умолчанию
Name[th]=ค่าเริ่มต้น
Name[tr]=Varsayılan
Name[uk]=Типово
Name[vi]=Mặc định
Name[zh_CN]=默认
Name[zh_TW]=預設
DefaultLayout=us
DefaultIM=keyboard-us

[Groups/0/Items/0]
Name=keyboard-us
Name[ar]=لوحة المفاتيح
Name[ast]=Tecláu
Name[bg]=Клавиатура
Name[ca]=Teclat
Name[cs]=Klávesnice
Name[da]=Tastatur
Name[de]=Tastatur
Name[el]=Πληκτρολόγιο
Name[en_GB]=Keyboard
Name[eo]=Klavaro
Name[es]=Teclado
Name[fi]=Näppäimistö
Name[fr]=Clavier
Name[he]=מקלדת
Name[hr]=Tipkovnica
Name[hu]=Billentyűzet
Name[it]=Tastiera
Name[ja]=キーボード
Name[ko]=키보드
Name[lt]=Klaviatūra
Name[nb]=Tastatur
Name[nl]=Toetsenbord
Name[pl]=Klawiatura
Name[pt]=Teclado
Name[pt_BR]=Teclado
Name[ru]=Клавиатура
Name[sk]=Klávesnica
Name[sv]=Tangentbord
Name[tr]=Klavye
Name[uk]=Клавіатура
Name[vi]=Bàn phím
Name[zh_CN]=键盘
Name[zh_TW]=鍵盤
Layout=us
Locale=pt_BR

[Groups/0/Items/1]
Name=keyboard-br
Name[ar]=لوحة المفاتيح
Name[ast]=Tecláu
Name[bg]=Клавиатура
Name[ca]=Teclat
Name[cs]=Klávesnice
Name[da]=Tastatur
Name[de]=Tastatur
Name[el]=Πληκτρολόγιο
Name[en_GB]=Keyboard
Name[eo]=Klavaro
Name[es]=Teclado
Name[fi]=Näppäimistö
Name[fr]=Clavier
Name[he]=מקלדת
Name[hr]=Tipkovnica
Name[hu]=Billentyűzet
Name[it]=Tastiera
Name[ja]=キーボード
Name[ko]=키보드
Name[lt]=Klaviatūra
Name[nb]=Tastatur
Name[nl]=Toetsenbord
Name[pl]=Klawiatura
Name[pt]=Teclado
Name[pt_BR]=Teclado
Name[ru]=Клавиатура
Name[sk]=Klávesnica
Name[sv]=Tangentbord
Name[tr]=Klavye
Name[uk]=Клавіатура
Name[vi]=Bàn phím
Name[zh_CN]=键盘
Name[zh_TW]=鍵盤
Layout=br
Locale=pt_BR

[Groups/0/Items/2]
Name=keyboard-br-abnt2
Name[ar]=لوحة المفاتيح
Name[ast]=Tecláu
Name[bg]=Клавиатура
Name[ca]=Teclat
Name[cs]=Klávesnice
Name[da]=Tastatur
Name[de]=Tastatur
Name[el]=Πληκτρολόγιο
Name[en_GB]=Keyboard
Name[eo]=Klavaro
Name[es]=Teclado
Name[fi]=Näppäimistö
Name[fr]=Clavier
Name[he]=מקלדת
Name[hr]=Tipkovnica
Name[hu]=Billentyűzet
Name[it]=Tastiera
Name[ja]=キーボード
Name[ko]=키보드
Name[lt]=Klaviatūra
Name[nb]=Tastatur
Name[nl]=Toetsenbord
Name[pl]=Klawiatura
Name[pt]=Teclado
Name[pt_BR]=Teclado
Name[ru]=Клавиатура
Name[sk]=Klávesnica
Name[sv]=Tangentbord
Name[tr]=Klavye
Name[uk]=Клавіатура
Name[vi]=Bàn phím
Name[zh_CN]=键盘
Name[zh_TW]=鍵盤
Layout=br-abnt2
Locale=pt_BR
EOF

    log_success "Configuração do fcitx5 criada!"
}

# Function to update Hyprland env config
update_hyprland_env() {
    log_header "Atualizando configuração do Hyprland"
    
    # Update env.conf to use fcitx5 instead of fcitx
    sed -i 's/fcitx/fcitx5/g' ~/.config/hypr/hyprland/env.conf
    
    log_success "Configuração do Hyprland atualizada para fcitx5!"
}

# Function to set system locale
set_system_locale() {
    log_header "Configurando locale do sistema"
    
    # Set keyboard layout
    sudo localectl set-keymap br-abnt2
    sudo localectl set-x11-keymap br abnt2
    
    log_success "Layout do teclado configurado para BR ABNT2!"
}

# Function to create autostart service
create_autostart() {
    log_header "Criando serviço de autostart"
    
    # Create systemd user service for fcitx5
    cat > ~/.config/systemd/user/fcitx5.service << 'EOF'
[Unit]
Description=Fcitx5 Input Method
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/fcitx5
Restart=on-failure
RestartSec=3
Environment=QT_IM_MODULE=fcitx5
Environment=GTK_IM_MODULE=fcitx5
Environment=XMODIFIERS=@im=fcitx5
Environment=SDL_IM_MODULE=fcitx5
Environment=GLFW_IM_MODULE=fcitx5

[Install]
WantedBy=graphical-session.target
EOF

    # Enable the service
    systemctl --user enable fcitx5.service
    
    log_success "Serviço fcitx5 criado e habilitado!"
}

# Function to show help
show_help() {
    echo "Script para configurar teclado BR (Brasil)"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -i, --install  Install fcitx5 packages"
    echo "  -c, --config   Configure fcitx5 for BR"
    echo "  -a, --all      Do everything (install + configure)"
    echo ""
    echo "This script will:"
    echo "  1. Install fcitx5 and related packages"
    echo "  2. Configure fcitx5 for Brazilian keyboard layout"
    echo "  3. Update Hyprland environment variables"
    echo "  4. Set system keyboard layout to BR ABNT2"
    echo "  5. Create autostart service for fcitx5"
}

# Main function
main() {
    local install_only=false
    local config_only=false
    local do_all=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -i|--install)
                install_only=true
                shift
                ;;
            -c|--config)
                config_only=true
                shift
                ;;
            -a|--all)
                do_all=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    if [[ "$install_only" == true ]]; then
        install_fcitx5
    elif [[ "$config_only" == true ]]; then
        configure_fcitx5
        update_hyprland_env
        set_system_locale
        create_autostart
    elif [[ "$do_all" == true ]]; then
        install_fcitx5
        configure_fcitx5
        update_hyprland_env
        set_system_locale
        create_autostart
    else
        log_info "Configurando teclado BR..."
        configure_fcitx5
        update_hyprland_env
        set_system_locale
        create_autostart
    fi
    
    log_header "Configuração Completa!"
    log_success "🇧🇷 Teclado BR configurado com sucesso! 🇧🇷"
    log_info "Para aplicar as mudanças:"
    log_info "  1. Reinicie o Hyprland (logout/login)"
    log_info "  2. Ou execute: systemctl --user restart fcitx5.service"
    log_info "  3. Use Ctrl+Space para alternar entre layouts"
    echo ""
    log_info "Layouts disponíveis:"
    log_info "  - US (padrão)"
    log_info "  - BR (Brasil)"
    log_info "  - BR ABNT2 (Brasil com teclas especiais)"
}

# Run main function
main "$@"
