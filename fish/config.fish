# Fish shell configuration
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"

# Set PATH
set -gx PATH $PATH "$HOME/.local/bin"

# Aliases
alias ll "ls -la"
alias la "ls -A"
alias l "ls -CF"
alias .. "cd .."
alias ... "cd ../.."
alias grep "grep --color=auto"
alias fgrep "fgrep --color=auto"
alias egrep "egrep --color=auto"

# Git aliases
alias gs "git status"
alias ga "git add"
alias gc "git commit"
alias gp "git push"
alias gl "git log --oneline"

# System aliases
alias update "sudo pacman -Syu"
alias install "sudo pacman -S"
alias remove "sudo pacman -R"
alias search "pacman -Ss"

# Hyprland aliases
alias hypr-reload "hyprctl reload"
alias hypr-workspaces "hyprctl workspaces"
alias hypr-windows "hyprctl clients"

# Quickshell aliases
alias qs-restart "pkill -f 'qs -c ii' && sleep 2 && qs -c ii &"
alias qs-kill "pkill -f 'qs -c ii'"

# Lock screen configuration
set -gx LOCK_SCREEN_CMD "/home/dxt/.local/bin/quickshell-lock"
set -gx XDG_CURRENT_DESKTOP "Quickshell"
set -gx DESKTOP_SESSION "quickshell"

# Welcome message
# echo "🐟 Fish shell carregado com sucesso!"
# echo "💡 Dica: Use 'help' para ver os comandos disponíveis"
