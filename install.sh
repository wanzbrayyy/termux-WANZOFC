#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Placeholder Functions ---

preview_theme() {
    clear
    # We need toilet for the preview, let's ensure it's installed.
    if ! command -v toilet &> /dev/null; then
        echo -e "${YELLOW}Installing 'toilet' for preview...${NC}"
        pkg install -y toilet
    fi

    toilet -f standard -F metal "RedDarkID"
    echo -e "${GREEN}      Owned by WANZOFC${NC}"
    echo ""
    echo -e "${YELLOW}Loading Preview...${NC}"
    # Progress bar
    for i in {1..50}; do
        echo -ne "\r${BLUE}["
        for ((j=0; j<i; j++)); do echo -n "█"; done
        for ((j=i; j<50; j++)); do echo -n " "; done
        echo -n "] $((i*2))%${NC}"
        sleep 0.03
    done
    echo ""
    echo -e "${GREEN}Preview loaded.${NC}"
    sleep 1
    clear

    # Simulate the powerlevel10k prompt
    echo -e "Ini adalah contoh bagaimana prompt Anda akan terlihat dengan Powerlevel10k."
    echo -e "Anda memerlukan ${YELLOW}Nerd Font${NC} agar ikon dapat ditampilkan dengan benar."
    echo ""
    # A simplified, more robust prompt simulation that doesn't rely on complex Nerd Font characters
    echo -e "${BLUE}┌─(  user@RedDarkID ) - [~/some/dir] - [main]${NC}"
    echo -e "${BLUE}└─❯${NC} your_command_here"
    echo ""
    echo -e "${YELLOW}Prompt yang sebenarnya akan interaktif, berwarna, dan menunjukkan status git.${NC}"
    echo ""
    read -p "Tekan [Enter] untuk kembali ke menu utama..."
}

install_theme() {
    clear
    echo -e "${GREEN}Memulai proses instalasi RedDarkID...${NC}"

    # --- 1. Install Dependencies ---
    echo -e "${YELLOW}Langkah 1: Menginstal paket yang diperlukan...${NC}"
    pkg update -y && pkg upgrade -y
    # Install core packages, including ruby for lolcat and procps for pkill
    pkg install -y zsh git wget curl ruby termux-api procps

    # Install lolcat using gem
    echo "Menginstal lolcat..."
    gem install lolcat

    echo -e "${GREEN}Paket inti berhasil diinstal.${NC}"
    sleep 1

    # --- 1b. Verify Zsh installation ---
    if ! command -v zsh &> /dev/null; then
        echo -e "${RED}Instalasi Zsh tidak dapat diverifikasi. Silakan coba jalankan skrip ini lagi.${NC}"
        exit 1
    fi

    # --- 2. Download Sound Files ---
    echo -e "${YELLOW}Langkah 2: Mengunduh file suara...${NC}"
    MUSIC_DIR="$HOME/.termux/audio"
    mkdir -p "$MUSIC_DIR"
    wget -q -O "$MUSIC_DIR/hacker.mp3" https://files.catbox.moe/w2i31u.mp3
    echo -e "${GREEN}File suara berhasil diunduh.${NC}"
    sleep 1

    # --- 3. Backup existing config files ---
    echo -e "${YELLOW}Langkah 3: Mencadangkan file konfigurasi yang ada...${NC}"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    if [ -f "$HOME/.bashrc" ]; then
        mv "$HOME/.bashrc" "$HOME/.bashrc.bak.$TIMESTAMP"
        echo "File .bashrc Anda telah dicadangkan ke .bashrc.bak.$TIMESTAMP"
    fi
    if [ -f "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$TIMESTAMP"
        echo "File .zshrc Anda telah dicadangkan ke .zshrc.bak.$TIMESTAMP"
    fi
    sleep 1

    # --- 4. Install Oh My Zsh ---
    echo -e "${YELLOW}Langkah 4: Menginstal Oh My Zsh...${NC}"
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh sudah terinstal. Melewati..."
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        if [ $? -ne 0 ]; then
            echo -e "${RED}Instalasi Oh My Zsh gagal. Membatalkan.${NC}"
            exit 1
        fi
    fi
    echo -e "${GREEN}Oh My Zsh berhasil diinstal.${NC}"
    sleep 1

    # --- 5. Install Powerlevel10k Theme ---
    echo -e "${YELLOW}Langkah 5: Menginstal tema Powerlevel10k...${NC}"
    if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "Powerlevel10k sudah terinstal. Melewati..."
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
    echo -e "${GREEN}Tema Powerlevel10k berhasil diinstal.${NC}"
    sleep 1

    # --- 6. Install Zsh Plugins ---
    echo -e "${YELLOW}Langkah 6: Menginstal plugin Zsh (autosuggestions & syntax-highlighting)...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo -e "${GREEN}Plugin berhasil diinstal.${NC}"
    sleep 1

    # --- 7. Configure .zshrc ---
    echo -e "${YELLOW}Langkah 7: Mengkonfigurasi file .zshrc...${NC}"

    cat << 'EOF' > "$HOME/.zshrc"
# Enable Powerlevel10k instant prompt. Should stay at the top of .zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# --- RedDarkID Loading Animation ---
redd_loading_animation() {
    # Play music in background
    termux-media-player play "$HOME/.termux/audio/hacker.mp3" &

    if ! command -v toilet &> /dev/null; then
        pkg install -y toilet &> /dev/null
    fi
    if ! command -v lolcat &> /dev/null; then
        gem install lolcat &> /dev/null
    fi

    clear
    figlet -f slant "RedDarkID" | lolcat
    echo -e "\033[0;32m      Owned by WANZOFC\033[0m"
    echo ""
    echo -e "\033[1;33mLoading...\033[0m"
    for i in {1..50}; do
        echo -ne "\r\033[0;34m["
        for ((j=0; j<i; j++)); do echo -n "█"; done
        for ((j=i; j<50; j++)); do echo -n " "; done
        echo -n "] $((i*2))%\033[0m"
        sleep 0.03
    done
    echo ""
    sleep 1

    # Stop music by killing the process
    pkill termux-media-player &> /dev/null

    clear

    # Redefine the function to do nothing after the first run
    redd_loading_animation() {
        return 0
    }
}

# Run the animation function once
redd_loading_animation

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF

    # --- 6b. Create .p10k.zsh configuration ---
    cat << 'EOF' > "$HOME/.p10k.zsh"
# Powerlevel10k prompt configuration file.
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=255
POWERLEVEL9K_DIR_ANCHOR_BACKGROUND=4
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='green'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='yellow'
POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE_VI_MODE=true
POWERLEVEL9K_STATUS_OK_FOREGROUND='green'
POWERLEVEL9K_STATUS_ERROR_FOREGROUND='red'
POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
EOF
    echo -e "${GREEN}File .zshrc dan .p10k.zsh berhasil dibuat.${NC}"
    sleep 1

    # --- 8. Set Zsh as default shell ---
    echo -e "${YELLOW}Langkah 8: Menjadikan Zsh sebagai shell default...${NC}"
    chsh -s zsh

    # --- 9. Suppress Termux MOTD ---
    echo -e "${YELLOW}Langkah 9: Menonaktifkan pesan selamat datang Termux...${NC}"
    touch "$HOME/.hushlogin"

    echo -e "${GREEN}INSTALASI SELESAI!${NC}"
    echo -e "${YELLOW}Keluar dari skrip. Silakan mulai ulang Termux Anda untuk melihat perubahan.${NC}"
    sleep 3
    exit 0
}

uninstall_theme() {
    clear
    echo -e "${RED}PERINGATAN: Ini akan menghapus semua konfigurasi RedDarkID (Oh My Zsh, Powerlevel10k) dan mencoba mengembalikan konfigurasi shell Anda sebelumnya.${NC}"
    read -p "Apakah Anda yakin ingin melanjutkan? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "${YELLOW}Uninstalasi dibatalkan.${NC}"
        sleep 2
        return
    fi

    echo -e "${YELLOW}Memulai proses uninstalasi...${NC}"

    # --- 1. Change shell back to bash ---
    echo "Mengembalikan shell default ke bash..."
    chsh -s bash
    sleep 1

    # --- 2. Remove Zsh config and theme files ---
    echo "Menghapus file konfigurasi dan tema..."
    rm -rf "$HOME/.oh-my-zsh"
    rm -f "$HOME/.zshrc"
    rm -f "$HOME/.p10k.zsh"
    rm -f "$HOME/.zsh_history"
    sleep 1

    # --- 3. Restore backed-up config files ---
    echo "Mencoba mengembalikan file konfigurasi dari cadangan..."
    LATEST_BASHRC_BAK=$(ls -t "$HOME/.bashrc.bak."* 2>/dev/null | head -n 1)
    if [ -f "$LATEST_BASHRC_BAK" ]; then
        mv "$LATEST_BASHRC_BAK" "$HOME/.bashrc"
        echo -e "${GREEN}File .bashrc berhasil dipulihkan.${NC}"
    else
        echo -e "${YELLOW}Tidak ada cadangan .bashrc yang ditemukan. Anda mungkin perlu membuat file baru.${NC}"
        touch "$HOME/.bashrc" # Create empty .bashrc if not exists
    fi

    LATEST_ZSHRC_BAK=$(ls -t "$HOME/.zshrc.bak."* 2>/dev/null | head -n 1)
    if [ -f "$LATEST_ZSHRC_BAK" ]; then
        mv "$LATEST_ZSHRC_BAK" "$HOME/.zshrc"
        echo -e "${GREEN}File .zshrc cadangan juga dipulihkan (jika ada).${NC}"
    fi
    sleep 1

    echo -e "${GREEN}UNINSTALASI SELESAI!${NC}"
    echo -e "Silakan mulai ulang Termux untuk menerapkan perubahan."
    read -p "Tekan [Enter] untuk kembali ke menu utama..."
}

# --- Main Menu ---
show_menu() {
    clear
    # Ensure figlet is installed for the menu
    if ! command -v figlet &> /dev/null; then
        echo -e "${YELLOW}Installing 'figlet' for menu...${NC}"
        pkg install -y figlet
    fi
    figlet -f slant "RedDarkID" | lolcat
    echo -e "${GREEN}       Installer by WANZOFC (Version 2.0)${NC}"
    echo -e "${RED}=====================================================${NC}"
    echo -e "${YELLOW}Pilih Opsi:${NC}"
    echo -e "${GREEN}1. Pratinjau Tema${NC}"
    echo -e "${GREEN}2. Pasang Tema RedDarkID${NC}"
    echo -e "${GREEN}3. Copot Tema (Uninstall)${NC}"
    echo -e "${RED}4. Keluar${NC}"
    echo -e "${RED}=====================================================${NC}"
}

# --- Main Loop ---
while true; do
    show_menu
    read -p "Masukkan pilihan Anda (1-4): " choice

    case $choice in
        1)
            preview_theme
            ;;
        2)
            install_theme
            ;;
        3)
            uninstall_theme
            ;;
        4)
            echo -e "${GREEN}Terima kasih telah menggunakan installer ini! Keluar...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Pilihan tidak valid. Silakan coba lagi.${NC}"
            sleep 2
            ;;
    esac
done
