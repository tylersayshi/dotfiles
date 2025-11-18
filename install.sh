#!/bin/bash
cp .gitconfig ~
mkdir -p ~/.config/fish/conf.d
mkdir -p ~/.config/ghostty
mkdir -p ~/bin
cp bin/* ~/bin/
cp config.ghostty ~/.config/ghostty/config
cp config.fish ~/.config/fish/config.fish
cp fnm.fish ~/.config/fish/conf.d/fnm.fish
brew bundle install
echo "Installed dotfiles"
