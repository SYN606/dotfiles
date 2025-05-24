# =============================
# 🐟 FISH CONFIG - CLEAN & POWERFUL
# =============================

# ─────────────────────────────
# 📁 NAVIGATION
# ─────────────────────────────
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'

# ─────────────────────────────
# 📂 FILE LISTING (EZA)
# ─────────────────────────────
alias ls 'eza -al --color=always --group-directories-first --icons'
alias ld 'eza -D --color=always --group-directories-first --icons'
alias ll 'eza -l --color=always --group-directories-first --icons'
alias l. 'eza -ald --color=always --group-directories-first --icons .*'

# ─────────────────────────────
# 🐱 FILE VIEWING
# ─────────────────────────────
alias cat 'bat --style=header --style=snip --style=changes'

# ─────────────────────────────
# 🔍 SYSTEM UTILITIES
# ─────────────────────────────
alias grep 'ugrep --color=auto'
alias ip 'ip -color'
alias hw 'hwinfo --short'
alias jctl 'journalctl -p 3 -xb'
alias grubup 'sudo update-grub'
alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
alias pacdiff 'sudo -H DIFFPROG=meld pacdiff'
alias rip 'expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'

# ─────────────────────────────
# 📦 PACKAGE MANAGEMENT
# ─────────────────────────────
alias pls 'sudo'
alias update 'pls pacman -Syu'
alias getpkg 'pls pacman -S --needed'
alias rmpkg 'pls pacman -Rns'
alias search 'yay -Ss'
alias aurget 'yay -S'

# ─────────────────────────────
# 🧹 SYSTEM CLEANING
# ─────────────────────────────
function cls-cache --description "Clear pacman cache"
    read -l -p "Clear all cached packages? (y/N) " confirm
    if test "$confirm" = "y"
        yes | pls pacman -Scc
    else
        echo "❌ Cancelled."
    end
end

function orphans --description "Remove orphaned packages"
    set ops (pacman -Qdtq)
    if test -n "$ops"
        echo "Removing orphan packages:"
        echo "$ops"
        sudo pacman -Rns $ops
        pls pacman -Sc
    else
        echo "✅ No orphans found."
    end
end

function mirrors --description "Update mirror list to fastest servers"
    pls reflector --verbose --sort rate -l 20 --save /etc/pacman.d/mirrorlist
end

# ─────────────────────────────
# 💻 SYSTEM MONITORING
# ─────────────────────────────
alias psmem 'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias big 'expac -H M "%m\t%n" | sort -h | nl'
alias btop 'btop --force-utf'

# ─────────────────────────────
# 🐍 PYTHON DEV TOOLS
# ─────────────────────────────
alias venv 'python -m venv env'
alias acvt 'source env/bin/activate.fish'

# ─────────────────────────────
# 🧰 MISC UTILITIES
# ─────────────────────────────
alias wget 'wget -c'
alias tarnow 'tar -acf '
alias untar 'tar -zxvf '

# ─────────────────────────────
# 🧼 HISTORY MANAGEMENT
# ─────────────────────────────
alias cls-hist 'builtin history clear'

# ─────────────────────────────
# 🎨 SHELL GREETING (optional)
# ─────────────────────────────
alias fastfetch 'fastfetch --colors-block-range-start 9 --colors-block-width 3'

fastfetch
