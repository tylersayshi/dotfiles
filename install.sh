#!/bin/bash
cp .gitconfig ~
cp .vimrc ~
mkdir -p ~/.config/fish/conf.d
cp config.fish ~/.config/fish/config.fish
cp fnm.fish ~/.config/fish/conf.d/fnm.fish
echo "Installed dotfiles"

