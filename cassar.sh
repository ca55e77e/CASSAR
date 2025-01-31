#!/bin/bash

# Define installation paths
DWM_DIR="$HOME/.local/src/dwm"
ST_DIR="$HOME/.local/src/st"

# Ensure script is not run as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root."
    exit 1
fi

echo "Updating system and installing dependencies..."
sudo dnf update -y
sudo dnf install -y git make gcc libX11-devel libXft-devel libXinerama-devel ncurses-devel xorg-x11-server-Xorg xinit xsetroot 

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

# Install Neovim and Vim
echo "Installing Neovim and Vim..."
sudo dnf install -y neovim vim-enhanced

# Configure Neovim
mkdir -p "$HOME/.config/nvim"
echo "set number" > "$HOME/.config/nvim/init.vim"

# Set DWM as the default window manager

echo "Setting up DWM as the default window manager..."

# Create an Xsession file for DWM (for GDM, SDDM, or LightDM)
sudo bash -c 'cat > /usr/share/xsessions/dwm.desktop' <<EOF
[Desktop Entry]
Name=DWM
Comment=Dynamic Window Manager
Exec=dwm
Type=Application
EOF

# Set up .xinitrc for users using startx
echo "exec dwm" > "$HOME/.xinitrc"
chmod +x "$HOME/.xinitrc"

# Set up .xsession for compatibility
echo "exec dwm" > "$HOME/.xsession"
chmod +x "$HOME/.xsession"

# Finish
echo "DWM has been set as your default window manager."
echo "If using a display manager (GDM, SDDM), select 'DWM' from the session menu before logging in."
echo "If using startx, simply run 'startx' to launch DWM."


