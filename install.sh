#!/bin/bash
# install.sh
# Installation script for termux-customization

# Update and upgrade packages
pkg update -y && pkg upgrade -y

# Install dependencies
echo "Installing dependencies..."
pkg install -y figlet toilet cmatrix lolcat ruby termux-api

echo "Installation complete!"

# --- Music Setup ---
echo "Downloading hacker theme music..."
MUSIC_DIR=~/.termux/audio
mkdir -p $MUSIC_DIR
wget -q -O $MUSIC_DIR/hacker.mp3 https://www.myinstants.com/media/sounds/matrix-music.mp3

# --- Animation and Shell Customization ---

echo "Setting up boot animation and shell..."

# Backup existing .bashrc if it exists
BASHRC_FILE=~/.bashrc
if [ -f "$BASHRC_FILE" ]; then
    cp "$BASHRC_FILE" "${BASHRC_FILE}.bak"
    echo "Backed up existing .bashrc to ${BASHRC_FILE}.bak"
fi

# Clear the .bashrc file to ensure our new config is the only one
# For this script's purpose, we provide a full replacement.
# The user is notified of the backup.
echo "" > $BASHRC_FILE

# Add the loading animation function to .bashrc
cat << 'EOF' >> $BASHRC_FILE
loading_animation() {
    # Play music in background
    termux-media-player play ~/.termux/audio/hacker.mp3 &

    clear
    toilet -f standard -F gay "ANONYMOUS"
    echo "====================================" | lolcat
    echo "  Welcome to Termux, Master" | lolcat
    echo "====================================" | lolcat
    echo ""
    echo "Loading..."
    # Simple progress bar
    for i in {1..50}; do
        echo -ne "\r["
        for ((j=0; j<i; j++)); do echo -n "#"; done
        for ((j=i; j<50; j++)); do echo -n " "; done
        echo -n "] $((i*2))%"
        sleep 0.05
    done
    echo ""
    echo "System booting up..." | lolcat
    sleep 1
    echo "Accessing mainframes..." | lolcat
    sleep 1
    echo "Bypassing security..." | lolcat
    sleep 1
    echo "SUCCESS! Welcome." | lolcat
    sleep 2

    # Stop music
    termux-media-player stop

    clear
}

# Call the function
loading_animation

# --- Shell Prompt Customization ---
# Set a custom "hacker" prompt
PS1='\[\e[31m\]\u@\h:\[\e[m\]\[\e[32m\]\w\$ \[\e[m\]'
EOF

echo "Setup complete! Restart Termux to see the changes."
