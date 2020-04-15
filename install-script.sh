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
add-apt-repository -y ppa:otto-kesselgulasch/gimp
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

# Spotify
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
apt update && apt install spotify-client

# Terraform
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
unzip terraform_${TER_VER}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TER_VER}_linux_amd64.zip

# VS code insiders
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
apt update && apt install -y code-insiders

# Slack
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.2-amd64.deb
apt install -y ./slack-desktop-*.deb
rm ./slack-desktop-*.deb

# Keybase
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
apt install -y ./keybase_amd64.deb

# Discord
snap install discord --classic

# Libre office
apt install -y libreoffice libreoffice-l10n-fr libreoffice-style-breeze
apt install -y libreoffice-style-elementary libreoffice-style-oxygen libreoffice-style-human  openclipart-libreoffice

# Chrome
wget -N -P /tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install /tmp/google-chrome-stable_current_amd64.deb

# Miniconda
wget -N -P /tmp https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /srv/conda
echo -e '# Miniconda initialization' >> ~/.bashrc
echo -e 'eval "$('/srv/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"' >> ~/.bashrc
echo -e '. "/srv/conda/etc/profile.d/conda.sh"' >> ~/.bashrc
chown -R 1000:1000 /srv/conda
chown -R 1000:1000 ~/.conda

# Final upgrade
rm ./*.deb
apt update
apt full-upgrade -y
apt autoremove -y

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
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'google-chrome.desktop', 'code_code.desktop', 'gnome-control-center.desktop', 'libreoffice-writer.desktop', 'libreoffice-calc.desktop']"
# Default to minimize
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-overview'
# Lock screen color
sudo sed -i "s/background: #2c001e/background: #3e8585/g" /usr/share/gnome-shell/theme/ubuntu.css
# Splach screen color
sudo sed -i "s/Window.SetBackgroundTopColor (0.16, 0.00, 0.12);/Window.SetBackgroundTopColor (0.243, 0.522, 0.522);/g" /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.script
sudo sed -i "s/Window.SetBackgroundBottomColor (0.16, 0.00, 0.12);/Window.SetBackgroundBottomColor (0.243, 0.522, 0.522);/g" /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.script
sudo update-initramfs -u
# Icon packages
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme/
./install.sh
cd ..
rm -fr Tela-icon-theme/

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

