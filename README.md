# Personal WorkStation
Welcome to my personal Arch Linux Scripts
This is intented to install and prepare everything to just use the system without thinking.
Based on [this Arch Installer by Bisanota](https://github.com/Bisanota/MeinArchInstaller) (old personal account).
This is intended to work with a bunch of tools and applications pre-installed.

## Few Considerations
- Script prepare and make ready for my personal configuration on my computers. Why not NixOS? NixOS works different and doesn't feels like linux when I try to make changes directly but not in a config file (.nix file).
- Works with KDE Plasma, and tries to be *"boring"* in order to be a productive focused system.
- Technically another Distro? Maybe, but works under Arch Linux base, and just prepare and install everything. Doesn't with so much changes.
- Some packages comes from AUR, through Chaotic-AUR repository, due missing time when is compiling.

# Content
Here are a list of files:
- main.sh : Script that detects if you meet some requeriments (and if you are in Live or not).
- preInstaller.sh : Install needed apps and let make partitions as the way anyone wants.
- installer.sh : Set up everything for being usable, and activates some things to just be usable when rebooting
- postInstaller.sh : Just put the appearence of KDE, installs and setups **zsh.sh** and **zRamSwap.sh**

- personalSetup.knsv : My KDE appearence
- packages.txt : Actually, here is not packages, but personal apps that I need and I don't want to forget

- arch-mac-style.zip : Plymouth style


*Personal Use, but config it as you would like to use :)*
