#!/bin/bash
#
# If this gets any more complicated it's going to need to be an atomic
# installation probably written in a more powerful language (python)
# or start using the packag manager

# install all packages in list
# The list was generated with pacman -Qqe
yaourt -S --needed - < pkglist.txt

cwd=$(pwd)
ln -fs "$cwd/.zshrc" ~/.zshrc
ln -fs "$cwd/init.vim" ~/.config/nvim/init.vim
ln -fs "$cwd/config" ~/config
ln -fs "$cwd/move-cursor-window-center.sh" ~/move-cursor-window-center.sh

