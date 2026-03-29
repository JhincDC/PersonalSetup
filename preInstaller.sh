#!/bin/bash

# Variables
intelBased="intel-ucode intel-media-driver vulkan-intel libva-intel-driver" # I put libva-intel-driver due is an old intel driver that is needed
modules="dkms linux-headers"
dualBoot="os-prober"
bsdLike="less inetutils bind lsof strace sysfsutils man-db man-pages"
utilities="vim nano wget rsync git dialog htop fastfetch tlp tmux" # fzf
core="base linux linux-firmware grub efibootmgr networkmanager base-devel bash-completion"
packages="$core $modules $dualBoot $bsdLike $utilities $intelBased"

# Functions
loadingFunction() {
echo -n "["
    bucleSleepNum=0
    bucleSleepMax=40
    while [ $bucleSleepNum -le $bucleSleepMax ]; do
    echo -n .
    sleep 0.04
    bucleSleepNum=$((bucleSleepNum + 1))
done
echo "]"
}

# Main

while true; do
clear
    echo "Partition Drives"
    echo "This part is manual"
    echo "Do not forget to mount your partition!!!"
    echo "You can use \"cfdisk\""
    echo "Mount partitions with this command: \"mount /directory\""
    echo "Mount root on /mnt , and EFI on /mnt/boot/efi"
    bash
    echo -n "Are you sure that you mount every partitions? [Y/N]: "
    read partDrivesSure
    if [[ "$partDrivesSure" == "Y" || "$partDrivesSure" == "y" ]]; then
        break
    fi
done

pacman -Sy --noconfirm archlinux-keyring
pacstrap -K /mnt $packages
genfstab -U /mnt >> /mnt/etc/fstab

cp installer.sh /mnt
arch-chroot /mnt bash /installer.sh

clear
echo "Finishing!"
rm /mnt/installer.sh
loadingFunction
umount -R /mnt

echo "Use PostInstaller for setting up and install everything else"
