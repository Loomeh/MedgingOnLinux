#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Detect the OS name
os_name=$(awk -F= '/^NAME=/ {print $2; exit}' /etc/*-release | tr -d '"')

# Check if the OS name was successfully detected
if [ -z "$os_name" ]; then
    echo "Failed to detect OS"
    exit 1
fi

# Display setup utility message and detected OS
echo -e "${RED}MedgingOnLinux setup utility${NC}"
echo "Detected OS: $os_name"

# Check if the OS is Arch Linux
if [ "$os_name" = "Arch Linux" ]; then
    # Prompt the user to update the system
    read -p "Do you want to update your operating system before continuing? It can prevent errors. (Y/N): " update_choice
    if [[ "$update_choice" =~ ^[Yy]$ ]]; then
        echo "Updating your operating system before continuing."
        if ! sudo pacman -Syu; then
            echo "Failed to update the system."
            exit 1
        fi
    fi

    xdeltapkg="xdelta3"
    # Check if xdelta3 is installed
    if pacman -Qs "${xdeltapkg}" >/dev/null; then
        echo -e "${GREEN}${xdeltapkg} is installed${NC}"
    else
        # Install xdelta3 if not installed
        if ! sudo pacman -S --noconfirm "${xdeltapkg}"; then
            echo "Failed to install ${xdeltapkg}."
            exit 1
        else
            echo -e "${GREEN}${xdeltapkg} is installed${NC}"
        fi
    fi
fi

# Check if the OS is Debian or Ubuntu
if [ "$os_name" = "Debian" ] || [ "$os_name" = "Ubuntu" ]; then
    # Prompt the user to update the system
    read -p "Do you want to update your operating system before continuing? It can prevent errors. (Y/N): " update_choice
    if [[ "$update_choice" =~ ^[Yy]$ ]]; then
        echo "Updating your operating system before continuing."
        if ! sudo apt update; then
            echo "Failed to update the system."
            exit 1
        fi
        if ! sudo apt upgrade -y; then
            echo "Failed to upgrade the system."
            exit 1
        fi
    fi

    xdeltapkg="xdelta3"
    # Check if xdelta3 is installed
    if apt list | grep "${xdeltapkg}" >/dev/null; then
        echo -e "${GREEN}${xdeltapkg} is installed${NC}"
    else
        # Install xdelta3 if not installed
        if ! sudo apt install -y "${xdeltapkg}"; then
            echo "Failed to install ${xdeltapkg}."
            exit 1
        else
            echo -e "${GREEN}${xdeltapkg} is installed${NC}"
        fi
    fi
fi

default_dir="$HOME/.local/share/Steam/steamapps/common/mirrors edge"
mirrors_edge_dir=""

# Check if the default directory exists
if [ -d "$default_dir" ]; then
    mirrors_edge_dir="$default_dir"
else
    # Prompt the user to enter the game's directory path
    read -p "Could not detect Mirror's Edge folder in Steam directory. Enter the game's directory path: " mirrors_edge_dir
    if [ ! -d "$mirrors_edge_dir" ]; then
        echo "Directory does not exist."
        exit 1
    fi
fi

# Resolve relative path to absolute path
mirrors_edge_dir=$(realpath "$mirrors_edge_dir")

# Patch the Mirror's Edge executable
echo -e "Patching Mirror's Edge executable"
if ! xdelta3 -f -d -s "${mirrors_edge_dir}/Binaries/MirrorsEdge.exe" "./gog_noloads_steam.xdelta" "${mirrors_edge_dir}/Binaries/MirrorsEdge.exe"; then
    echo "Failed to patch Mirror's Edge executable."
    exit 1
else
    echo -e "${GREEN}Mirror's Edge executable patched!${NC}"
fi

# Prompt the user to enter the LiveSplit folder path
read -p "Enter the directory path of your LiveSplit folder: " livesplit_dir
if [ ! -d "$livesplit_dir" ]; then
    echo "Directory does not exist."
    exit 1
fi

# Resolve relative path to absolute path
livesplit_dir=$(realpath "$livesplit_dir")

# Download the latest multiplayer release
LAUNCHER_URL=$(curl -s https://api.github.com/repos/Toyro98/mmultiplayer/releases/latest | grep -oP '"browser_download_url": "\K(.*Launcher.exe)(?=")')
DLL_URL=$(curl -s https://api.github.com/repos/Toyro98/mmultiplayer/releases/latest | grep -oP '"browser_download_url": "\K(.*mmultiplayer.dll)(?=")')
if [ -n "$LAUNCHER_URL" ] && [ -n "$DLL_URL" ]; then
    if wget -q -O Launcher.exe "$LAUNCHER_URL" && wget -q -O mmultiplayer.dll "$DLL_URL"; then
        echo -e "${GREEN}Launcher.exe and mmultiplayer.dll downloaded successfully!${NC}"
    else
        echo -e "${RED}Failed to download Launcher.exe or mmultiplayer.dll.${NC}"
        exit 1
    fi
else
    echo -e "${RED}No matching files found for Launcher.exe or mmultiplayer.dll in the latest release.${NC}"
    exit 1
fi

echo "Copying Multiplayer Mod"
if ! cp Launcher.exe "${mirrors_edge_dir}/Binaries/" || ! cp mmultiplayer.dll "${mirrors_edge_dir}/Binaries/"; then
    echo "Failed to copy Launcher.exe or mmultiplayer.dll."
    exit 1
fi

echo "Copying Speedometer"
if ! cp Speedometer.exe "${mirrors_edge_dir}/Binaries/"; then
    echo "Failed to copy Speedometer."
    exit 1
fi

echo "Creating batch files"

cat <<EOF >launch_normal.bat
start "" "Z:${mirrors_edge_dir//\//\\}\\Binaries\\MirrorsEdge.exe"
start "" "Z:${livesplit_dir//\//\\}\\LiveSplit.exe"
EOF

cat <<EOF >launch_speedometer.bat
start "" "Z:${mirrors_edge_dir//\//\\}\\Binaries\\MirrorsEdge.exe"
start "" "Z:${livesplit_dir//\//\\}\\LiveSplit.exe"
start "" "Z:${mirrors_edge_dir//\//\\}\\Binaries\\Speedometer.exe"
EOF

cat <<EOF >launch_mmod.bat
start "" "Z:${mirrors_edge_dir//\//\\}\\Binaries\\MirrorsEdge.exe"
start "" "Z:${mirrors_edge_dir//\//\\}\\Binaries\\Launcher.exe"
start "" "Z:${livesplit_dir//\//\\}\\LiveSplit.exe"
EOF

echo -e "${GREEN}All done!${NC} ${RED}Happy Medging!${NC}"
echo -e "Next steps:\n1. Add launch_normal.bat, launch_speedometer.bat, and launch_mmod.bat as Non-Steam games in Steam.\n2. In each batch file's Steam properties, go to Properties and enable \"Force the use of a compatibility tool\" and select the latest Proton version."
echo -e "Report any issues at https://github.com/Loomeh/MedgingOnLinux or in the Mirror's Edge Discord."
