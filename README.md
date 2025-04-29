# MedgingOnLinux
MedgingOnLinux is a script that's designed to help get people speedrunning Mirror's Edge on Linux.

### Prerequisites
- You have the Steam version installed (support for Origin may be added at some point).
- You already have your GPU drivers sorted out. Read [this page](https://github.com/lutris/docs/blob/master/InstallingDrivers.md) on the Lutris wiki if you aren't sure.
- You are running a supported distro.


### Supported distros
- Arch Linux (and all derivatives, such as Manjaro or ElementaryOS)
- Debian/Ubuntu (and all derivatives, such as Linux Mint or Pop_OS!)
- NixOS
- Fedora


### Usage
**Download the repository as a ZIP file by clicking on the Code button or clone with Git**
```
git clone https://github.com/Loomeh/MedgingOnLinux
```

Run the script
```
cd MedgingOnLinux/
chmod +x MedgingOnLinux.sh
./MedgingOnLinux.sh
```

The script will guide you through the process. Make sure to read the instructions at the end, they're important!


### Troubleshooting / FAQ
#### - The script says it failed to patch the executable
Read the error that the script produced. If it says "checksum mismatch" anywhere, it means that the Mirror's Edge executable has already been modified and is not the original Steam executable. Verify the game's integrity in Steam and try again.

If it says it can't find the file, it means you entered your Mirror's Edge game directory incorrectly.


#### - Why is it asking for my LiveSplit directory? I thought LiveSplit didn't run on Linux
It doesn't. LiveSplit runs through Wine. The purpose of the script is to make it so the autosplitter connection between Mirror's Edge and LiveSplit functions correctly.


#### - I get a "Failed to find D3D9 exports" error when trying to launch Multiplayer Mod.
This is a known issue and is seemingly an issue with the Multiplayer Mod itself and cannot be fixed within Proton/Wine. The only potential remedy is to try and use the old Multiplayer Mod by btbd. Otherwise, just wait.


#### - What mods can I use?
The only game file the script touches is the MirrorsEdge.exe executable file. Any mod that doesn't replace that file is fine.


#### - LiveSplit looks weird/glitchy
This is because the Mirror's Edge Proton wine prefix doesn't come with many Windows dependencies by default, leading to LiveSplit looking weird. This can be fixed by using a Proton package that comes with more built in Windows dependencies (such as Proton-GE) or by installing corefonts via Protontricks.