#!/bin/bash
#
# If this gets any more complicated it's going to need to be an atomic
# installation probably written in a more powerful language (python)
# or start using the packag manager

# install all packages in list
# The list was generated with pacman -Qqet
#
# TODO TEMPORARY: This makes it work, but filters out packages from the AUR
lst=$(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))
sudo pacman -S --needed $lst

# install zgen
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# Path of script. Needs to be run from
DIR=$(dirname "$(readlink -f "$0")")

# Install script to stop screen lock when watching media
sudo ln -fs "$DIR/keep-awake.sh" /usr/bin/keep-awake

# Install service for locking screen when computer sleeps
sudo ln -fs "$DIR/lock" /usr/bin/lock
sudo ln -fs "$DIR/sleeplock.service" /etc/systemd/system/sleeplock.service

# make zsh the default shell
chsh -s $(which zsh)

# use ntp
sudo timedatectl set-ntp true

# install config files
ln -fs "$DIR/.zshrc" ~/.zshrc

mkdir ~/.config/nvim
ln -fs "$DIR/init.vim" ~/.config/nvim/init.vim

ln -fs "$DIR/config" ~/.i3/config
ln -fs "$DIR/move-cursor-window-center.sh" ~/.i3/move-cursor-window-center.sh

mkdir ~/.config/termite
ln -fs "$DIR/termite-config" ~/.config/termite/config

ln -fs "$DIR/xfce4-power-manager.xml" ~/.config/xfce4/xfconf/xfce-perchannel-xml
