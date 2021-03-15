#!/bin/bash
# Script de post-installation pour Ubuntu 18.04
set -e

# A faire manuellement a la fin du script
#
# Pour libre office :
# --- Affichage > Tab
# --- Outils > Options > Affichage > Style d'icône : Colibre
#
# Terminal:
# --- Edition > Preferences > Couleurs
# --- Decocher theme systeme > Tango sombre
#
# VS Code:
# --- Configure sync: https://code.visualstudio.com/docs/editor/settings-sync
#
# Chrome
# --- Download dir: /tmp
#
# Install Ant theme from
# https://github.com/EliverLara/Ant/releases/download/v1.3.0/Ant.tar
# in /usr/share/themes then
# --- gsettings set org.gnome.desktop.interface gtk-theme "Ant"
# --- gsettings set org.gnome.desktop.wm.preferences theme "Ant"
#
# Activate nvidia graphics driver


# Initial upgrade
apt update
apt full-upgrade -y
apt autoremove -y

# Add apt repos
# add-apt-repository -y ppa:otto-kesselgulasch/gimp
add-apt-repository -y ppa:libreoffice/ppa
apt update

# Apt installs
apt install -y inkscape
apt install -y dconf-editor
apt install -y gnome-tweak-tool
apt-get install -y git
apt-get install -y curl
apt-get install -y gparted
apt-get install -y docker.io
apt-get install -y gimp
apt install gnome-shell-extensions
apt install peek

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
apt update && apt install spotify-client

# VS code insiders
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
apt update && apt install -y code

# Slack
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.13.0-amd64.deb
apt install -y ./slack-desktop-*.deb
rm ./slack-desktop-*.deb

# Keybase
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
apt install -y ./keybase_amd64.deb

# Discord
snap install discord --classic

# Free office
wget https://www.softmaker.net/down/softmaker-freeoffice-2018_982-01_amd64.deb
apt install ./softmaker-freeoffice-2018_982-01_amd64.deb
/usr/share/freeoffice2018/add_apt_repo.sh

# Chrome
wget -N -P /tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install /tmp/google-chrome-stable_current_amd64.deb

# Miniconda
wget -N -P /tmp https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /srv/conda
/srv/conda/bin/conda init
chown -R 1000:1000 /srv/conda
chown -R 1000:1000 ~/.conda

# Azure CLI
apt install -y ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
apt update
apt install -y azure-cli
az login

# DisplayLink
git clone https://github.com/AdnanHodzic/displaylink-debian.git
cd displaylink-debian
./displaylink-debian.sh


# Steelseries Rival 100 driver
sudo apt install -y build-essential python-dev libusb-1.0-0-dev libudev-dev
pip install rivalcfg
#sudo /srv/conda/bin/rivalcfg -c '#AA0505'

# Final upgrade
rm ./*.deb
apt update
apt full-upgrade -y
apt autoremove -y

# Ubuntu 20.04 change login color
sudo apt install git libglib2.0-dev
git clone https://github.com/PRATAP-KUMAR/focalgdm3.git
sudo ./focalgdm3/focalgdm3 --set

# Alt+Tab
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
# Dock at bottom
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
#Show date in top menu
gsettings set org.gnome.desktop.interface clock-show-date true
# Hide mounted volumes in desktop
gsettings set org.gnome.nautilus.desktop volumes-visible false
# Screenshot directory to /tmp
gsettings set org.gnome.gnome-screenshot auto-save-directory "/tmp"
# Default applications in dock 
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'google-chrome.desktop', 'spotify.desktop', 'code.desktop', 'gnome-control-center.desktop']"
# Default to minimize
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-overview'
# Lock screen color
sudo sed -i "s/background: #2c001e/background: #E74C3C/g" /usr/share/gnome-shell/theme/ubuntu.css
# Splach screen color
sudo sed -i "s/Window.SetBackgroundTopColor (0.16, 0.298, 0.235);/Window.SetBackgroundTopColor (0.906, 0.522, 0.522);/g" /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.script
sudo sed -i "s/Window.SetBackgroundBottomColor (0.16, 0.298, 0.235);/Window.SetBackgroundBottomColor (0.90676/, 0.522, 0.522);/g" /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.script
sudo update-initramfs -u

# Install all google fonts
bash install-google-fonts.sh

# Git configuration
git config --global user.name "Valentin Biasi"
git config --global user.email valentin.biasi@weatherforce.org
git config --global core.editor nano
git config --global color.ui true

# ssh key
ssh-keygen -t rsa -b 4096 -q -P ""

# Docker config
groupadd docker || true
usermod -aG docker $USER || true
newgrp docker || true


# Theme
apt install sassc optipng libglib2.0-dev-bin 
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme

# Icon packages
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme/
./install.sh
cd ..
rm -fr Tela-icon-theme/


