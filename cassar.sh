#!/bin/bash

# Define installation paths
DWM_DIR="$HOME/.local/src/dwm"
ST_DIR="$HOME/.local/src/st"

# Ensure script runs as a normal user, not root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root."
    exit 1
fi

echo "Updating system and installing dependencies..."
sudo dnf update -y
sudo dnf install -y git make gcc libX11-devel libXft-devel libXinerama-devel ncurses-devel 

# Create directories
mkdir -p "$HOME/.local/src"

# Install DWM
if [ ! -d "$DWM_DIR" ]; then
    echo "Cloning and installing DWM..."
    git clone https://git.suckless.org/dwm "$DWM_DIR"
    cd "$DWM_DIR" || exit
    make
    sudo make install
else
    echo "DWM already installed."
fi

# Install ST (Simple Terminal)
if [ ! -d "$ST_DIR" ]; then
    echo "Cloning and installing ST..."
    git clone https://git.suckless.org/st "$ST_DIR"
    cd "$ST_DIR" || exit
    make
    sudo make install
else
    echo "ST already installed."
fi

# Install Neovim
echo "Installing Neovim..."
sudo dnf install -y neovim

# Install Vim
echo "Installing Vim..."
sudo dnf install -y vim-enhanced

# Create config directories for Neovim
mkdir -p "$HOME/.config/nvim"
echo "set number" > "$HOME/.config/nvim/init.vim"

# Finish
echo "Installation complete. Restart your session to use DWM."

