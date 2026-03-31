#!/bin/bash

# Constants
TOTAL_STEPS=7
CURRENT_STEP=0

# Variables
mbrgptselection=0

printer="cups cups-pdf avahi nss-mdns"
chaoticAUR="brave-bin epson-inkjet-printer-escpr" #. Epson Printer Drivers Installed
scanner="sane"
optional="htop fastfetch ufw gamemode lib32-gamemode jdk21-openjdk dnsmasq"
fonts="ttf-dejavu noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-droid ttf-freefont ttf-liberation ttf-opensans ttf-roboto ttf-roboto-mono ttf-jetbrains-mono ttf-ms-fonts otf-latinmodern-math ttf-gentium-plus adobe-source-code-pro-fonts ttf-ubuntu-font-family ttf-cascadia-code ttf-carlito"
audio="pipewire pipewire-alsa pipewire-pulse pipewire-jack alsa-utils wireplumber"
video="mesa mesa-utils"
vulkan="vulkan-tools vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers lib32-vulkan-intel vulkan-intel vulkan-swrast lib32-vulkan-swrast"
codecs="ffmpeg gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav lib32-libpulse lib32-alsa-plugins lib32-openal lib32-gnutls libva-utils"
reproductor="mpv"
filesystem="ntfs-3g dosfstools btrfs-progs zip unzip p7zip unrar exfatprogs fuse2"
extras="plymouth kdenlive musescore audacity gimp gimp-plugin-gmic inkscape digikam darktable blender krita krita-plugin-gmic libreoffice-fresh obs-studio libva-intel-driver v4l2loopback-dkms yay natron tlp openutau lttng-ust2.12 dotnet-runtime-8.0 scribus qtractor ardour vscodium font-manager gpick imagemagick pdfarranger qpwgraph helvum colord colord-kde lsp-plugins lsp-dsp-lib calf fluidsynth ripgrep fd eza bat rust lldb gdb texlab clang git cmake ninja llvm bash-language-server python python-pip obsidian libdbusmenu-glib gvfs asciidoctor"
guiServices="system-config-printer network-manager-applet simple-scan"
plasma="sddm plasma konsole dolphin ark kate okular gwenview kcalc filelight kdeconnect partitionmanager ksshaskpass konsave"
packages="$printer $chaoticAUR $scanner $optional"
packages1="$fonts $audio $video $vulkan $codecs $reproductor"
packages2="$filesystem $services $extras $guiServices"
de="$plasma"


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

addChaoticAUR() {
    pacman-key --recv-key 3056513887B78AEB
    pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    echo -e "\n#Multilib\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    echo -e "\n#Chaotic AUR\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
    sudo sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf
    sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
}

chooseMBRorGPT() {
while true; do
    choosingMBRorGPT=$(dialog --backtitle "You are installing Arch Linux" \
        --clear \
        --title "Select an option" \
        --menu "Choose one:" 10 40 2 \
        1 "MBR" \
        2 "GPT" \
        3>&1 1>&2 2>&3)

            case $choosingMBRorGPT in
                1)
                    discoMBRorGPT="grub-install --target=i386-pc /dev/sda"
                    mbrgptselection="MBR"
                    break
                    ;;
                2)
                    discoMBRorGPT="grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchBTW"
                    mbrgptselection="GPT"
                    break
                    ;;
                *)
                    echo "Not valid entry."
                    sleep 1
                    ;;
            esac


done
}

machineName() {
    machine=$(dialog --backtitle "You are installing Arch Linux" \
                    --title "Machine Name" \
                    --stdout \
                    --inputbox "Enter machine name:" 0 0)
}

principalUser() {
    dialog --backtitle "You are installing Arch Linux" \
        --title "REMEMBER" \
        --msgbox "For now, you'll have just a lonely user.\nYou can add more in postinstallation." 0 0

    user=$(dialog --backtitle "You are installing Arch Linux" \
                    --title "User name all in lowercase please" \
                    --stdout \
                    --inputbox "Enter your user name that you want to login in the machine, all in lowercase please:" 0 0)
    user=${user,,}
}

update_progress() {
    local message=$1
    ((CURRENT_STEP++))
    local percent=$(( CURRENT_STEP * 100 / TOTAL_STEPS ))
    echo "XXX"
    echo "$message"
    echo "XXX"
    echo "$percent"
}


# Main

dialog --backtitle "You are installing Arch Linux" \
        --title "HOW TO USE THIS" \
        --msgbox "Just write the direction where the file region are, based on the two windows above text region.\nDO NOT PRESS OK IF YOU HAVE NOT SELECTED YOUR REGION\n\nWith TAB key you can change between windows and buttons" 0 0

dialog --backtitle "You are installing Arch Linux" \
        --title "Note" \
        --msgbox "If you don't know, just write UTC next to /usr/share/zoneinfo/\nAnd it looks like this:\n/usr/share/zoneinfo/UTC" 0 0


region=$(dialog --title "Select your region" \
                --stdout \
                --fselect /usr/share/zoneinfo/  14 70)
ln -sf ${region} /etc/localtime
hwclock --systohc
clear

dialog --backtitle "You are installing Arch Linux" \
        --title "Language" \
        --msgbox "At the moment, installer is available US_English Only" 0 0
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

addChaoticAUR

while true; do
    choice=$(dialog --clear \
        --backtitle "You are installing Arch Linux" \
        --title "Main Menu" \
        --menu "Choose an option:" 15 50 4 \
        1 "Choose MBR or GPT" \
        2 "Choose Machine Name" \
        3 "Choose Main Username" \
        4 "Continue" \
        3>&1 1>&2 2>&3)

    status=$?
    clear

    if [ $status -ne 0 ]; then
        break
    fi

    case "$choice" in
        1)
            chooseMBRorGPT
            ;;
        2)
            machineName
            ;;
        3)
            principalUser
            ;;
        4)
            dialog --backtitle "You are installing Arch Linux" \
                --title "SUMMARY" \
                --yesno "Disk Style: $mbrgptselection\nMachineName: $machine\nUser name (lowercase): $user\nAre you sure?" 0 0
            response=$?
            clear
            if [ $response -eq 0 ]; then
                break
            fi
            ;;
    esac
done

useradd -m -G wheel -s /bin/bash "$user"


password=$(dialog --backtitle "You are installing Arch Linux" \
                --title "$user Password" \
                --stdout \
                --insecure \
                --passwordbox "Introduce User Password:" 0 0)
echo "$user:$password" | chpasswd

dialog --backtitle "You are installing Arch Linux" \
       --title "Root Password" \
       --yesno "Same User Password for Root?" 0 0
       response=$?
       clear

if [ $response -eq 0 ]; then
clear
else
password=$(dialog --backtitle "You are installing Arch Linux" \
                --title "Root Password" \
                --stdout \
                --insecure \
                --passwordbox "Introduce Root Password:" 0 0)
fi
echo "root:$password" | chpasswd
password=0






dialog --backtitle "You are installing Arch Linux" \
       --title "FINISHING!" \
       --msgbox "This is the last step." 0 0


(
    update_progress "Enabling sudoers"
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
    sleep 1

    update_progress "Enabling GRUB"
    sed -i '/GRUB_DISABLE_OS_PROBER=/d' /etc/default/grub
    echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
    sleep 1

    update_progress "Enabling hosts"
    echo "$machine" > /etc/hostname
    bash -c "cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $machine.localdomain $machine
EOF"
    sleep 1


    update_progress "Installing grub"
    $discoMBRorGPT
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash video=1366x768"/' /etc/default/grub
    sed -i 's/^#GRUB_GFXMODE=.*$/GRUB_GFXMODE=1366x768x32/' /etc/default/grub
    sed -i 's/^#GRUB_GFXPAYLOAD_LINUX=.*$/GRUB_GFXPAYLOAD_LINUX=keep/' /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
    sleep 1

    update_progress "Enabling Networks"
    systemctl enable NetworkManager
    sleep 1

    update_progress "Making some Tweaks"
    sleep 1

    update_progress "Finishing Main Installation"
    sleep 2

) | dialog --backtitle "You are installing Arch Linux" \
    --title "Installing System" \
    --gauge "Starting..." 10 75 0

clear
echo "Basic Installation Complete :)"
sleep 2
loadingFunction
echo "Starting final tweaks"
sleep 2
echo "This part may take a lot of time"
sleep 2
loadingFunction
pacman -Sy --noconfirm --needed $packages
pacman -Sy --noconfirm --needed $packages1
pacman -Sy --noconfirm --needed $packages2
pacman -Sy --noconfirm --needed $de


sed -i 's/^HOOKS=.*/HOOKS=(base systemd plymouth autodetect microcode modconf kms keyboard keymap sd-vconsole block filesystems fsck)/' /etc/mkinitcpio.conf
loadingFunction
systemctl enable sddm.service
systemctl enable cups
systemctl enable bluetooth
systemctl enable avahi-daemon.service

printf "[Theme]\nCurrent=breeze\n" > /etc/sddm.conf
set -e
if [ -d "/etc/brave" ]; then
    POLICY_DIR="/etc/brave/policies/managed"
elif [ -d "/etc/opt/brave" ]; then
    POLICY_DIR="/etc/opt/brave/policies/managed"
else
    POLICY_DIR="/etc/brave/policies/managed"
fi
sudo mkdir -p "$POLICY_DIR"
sudo tee "$POLICY_DIR/brave_policies.json" > /dev/null <<EOF
{
  "BraveRewardsDisabled": true,
  "BraveWalletDisabled": true,
  "BraveVPNDisabled": true,
  "BraveAIChatEnabled": false,
  "BraveStatsPingEnabled": false
}
EOF

sudo chmod 644 "$POLICY_DIR/brave_policies.json"
sudo chown root:root "$POLICY_DIR/brave_policies.json"

sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkinitcpio -P

echo "Installation Complete :)"
loadingFunction
