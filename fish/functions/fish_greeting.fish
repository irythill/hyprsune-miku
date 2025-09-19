function fish_greeting
    # Usar fastfetch se disponível
    if command -v fastfetch >/dev/null 2>&1

        echo ""
            echo -e (set_color -o cyan)"╔════════════════════════════════════════════════════╗"
            echo -e "║  🎵 One, two, three, ready? Miku Miku Miiiiiiii 🎵 ║"
            echo -e "╚════════════════════════════════════════════════════╝"(set_color normal)
        echo ""

        fastfetch --file ~/.config/fastfetch/hatsune_ascii.txt
        
    else
        # Fallback se fastfetch não estiver disponível
        echo -e (set_color -o cyan)"🐟 Fish shell carregado com sucesso!"
        echo -e "💡 Dica: Use 'help' para ver os comandos disponíveis"(set_color normal)
    end
end