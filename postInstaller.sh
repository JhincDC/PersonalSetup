#!/bin/bash
cat personalSetup_part_* > personalSetup.knsv
konsave -i personalSetup.knsv
sleep 1
konsave -a personalSetup

sudo pacman -S --needed --noconfirm zram-generator

sudo echo "[zram0]
zram-size = ram * 2
compression-algorithm = zstd
swap-priority = 80
fs-type = swap" > /etc/systemd/zram-generator.conf
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo swapon /swapfile
sudo mkswap /swapfile
sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab


git clone https://github.com/Bisanota/WineConfigs.git
cd WineConfigs
bash main.sh

unzip arch-mac-style.zip
sudo cp -r ./arch-mac-style /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R arch-mac-style

echo "Once you install ZSH and Oh My ZSH!, pls, put \"YES\" and type \"EXIT\""
sudo pacman -S --noconfirm --needed zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"



