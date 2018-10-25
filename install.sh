#!/bin/bash
#
# If this gets any more complicated it's going to need to be an atomic
# installation probably written in a more powerful language (python)
# or start using the packag manager

# install all packages in list
# The list was generated with pacman -Qqet
#
# TODO TEMPORARY: This makes it work, but filters out packages from the AUR
sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))

#install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cwd=$(pwd)
ln -fs "$cwd/.zshrc" ~/.zshrc
ln -fs "$cwd/init.vim" ~/.config/nvim/init.vim
ln -fs "$cwd/config" ~/.i3/config
ln -fs "$cwd/move-cursor-window-center.sh" ~/move-cursor-window-center.sh
mkdir ~/.config/termite
ln -fs "$cwd/termite-config" ~/.config/termite/config

# Install service for locking screen when computer sleeps
sudo ln -fs "$cwd/lock" /usr/bin/lock
sudo ln -fs "$cwd/sleeplock.service" /etc/systemd/system/sleeplock.service

# make zsh the default shell
chsh -s $(which zsh)

