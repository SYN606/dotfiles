#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# ========== COLOR DEFINITIONS ==========
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"
RESET="\e[0m"

# ========== WELCOME BANNER ==========
echo -e "${BLUE}======================================================"
echo -e "${YELLOW}💻  Arch Linux Dotfile Setup by ${GREEN}SYN606"
echo -e "${YELLOW}💻  github : https://github.com/syn606"
echo -e "${BLUE}======================================================${RESET}"

# ========== VARIABLES ==========
PACKAGES=(
  fish eza bat fastfetch expac yay paru ugrep btop hwinfo reflector meld
  tar wget p7zip xsel starship ttf-firacode-nerd ttf-jetbrains-mono ttf-cascadia-code
)
NVIM_CONFIG_REPO="https://github.com/NvChad/starter"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# ========== FUNCTIONS ==========

check_root_notice() {
  if [[ "$EUID" -ne 0 ]]; then
    echo -e "${YELLOW}🔒 Some actions require root. You will be prompted when needed.${RESET}"
  fi
}

check_internet() {
  echo -e "${BLUE}🌐 Checking internet connectivity...${RESET}"
  if ! ping -q -c 1 archlinux.org &>/dev/null; then
    echo -e "${RED}❌ No internet connection. Please connect and try again.${RESET}"
    exit 1
  fi
}

install_packages() {
  echo -e "${BLUE}📦 Installing required packages...${RESET}"
  for pkg in "${PACKAGES[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
      echo -e "${YELLOW}➡️ Installing ${GREEN}$pkg${RESET}"
      sudo pacman -S --noconfirm "$pkg"
    else
      echo -e "${GREEN}✔️ $pkg already installed${RESET}"
    fi
  done
}

install_nvim_config() {
  if [[ ! -d "$NVIM_CONFIG_DIR" ]]; then
    echo -e "${BLUE}📝 Cloning NvChad config...${RESET}"
    git clone "$NVIM_CONFIG_REPO" "$NVIM_CONFIG_DIR"
  else
    echo -e "${YELLOW}🔄 NvChad config already exists.${RESET}"
  fi
}

enable_chaotic_aur() {
  read -p "$(echo -e "${BLUE}🚀 Do you want to enable Chaotic AUR? (y/n): ${RESET}")" choice
  case "$choice" in
    y|Y|yes|YES)
      echo -e "${BLUE}🔑 Importing Chaotic AUR keys...${RESET}"
      sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
      sudo pacman-key --lsign-key 3056513887B78AEB
      echo -e "${BLUE}📦 Installing keyring and mirrorlist...${RESET}"
      sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
      sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
      echo -e "${BLUE}🔧 Updating pacman.conf...${RESET}"
      echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
      echo -e "${GREEN}✅ Chaotic AUR enabled!${RESET}"
      ;;
    n|N|no|NO)
      echo -e "${YELLOW}❌ Skipping Chaotic AUR setup.${RESET}"
      ;;
    *)
      echo -e "${RED}⚠️ Invalid input.${RESET}"
      enable_chaotic_aur
      ;;
  esac
}

handle_local_directory() {
  if [[ -d .local ]]; then
    read -p "$(echo -e "${BLUE}📁 Are you using Konsole (sync .local)? (y/n): ${RESET}")" choice
    case "$choice" in
      y|Y|yes|YES)
        echo -e "${BLUE}📂 Syncing .local to $HOME/.local/...${RESET}"
        rsync -av .local/ "$HOME/.local/"
        echo -e "${GREEN}✅ .local synced.${RESET}"
        ;;
      n|N|no|NO)
        echo -e "${YELLOW}🗑️ Deleting .local directory...${RESET}"
        rm -rf .local
        echo -e "${GREEN}✅ .local deleted.${RESET}"
        ;;
      *)
        echo -e "${RED}⚠️ Invalid input.${RESET}"
        handle_local_directory
        ;;
    esac
  fi
}

sync_configs() {
  [[ -d .config ]] && rsync -av .config/ "$HOME/.config/"
  [[ -d .vscode ]] && rsync -av .vscode/ "$HOME/"
  echo -e "${GREEN}✔️ Configs synced.${RESET}"
}

enable_starship_prompt() {
  CONFIG_PATH="$HOME/.config/fish/config.fish"
  LINE='starship init fish | source'
  if [[ -f "$CONFIG_PATH" && ! $(grep -Fx "$LINE" "$CONFIG_PATH") ]]; then
    echo "$LINE" >> "$CONFIG_PATH"
    echo -e "${GREEN}🌟 Starship prompt enabled in fish.${RESET}"
  fi
}

# ========== MAIN ==========
main() {
  check_root_notice
  check_internet
  install_packages
  install_nvim_config
  enable_chaotic_aur
  handle_local_directory
  sync_configs
  enable_starship_prompt
  echo -e "\n${GREEN}🎉 All done! Launch Neovim with \`nvim\` and enjoy your setup.${RESET}"
}

main
