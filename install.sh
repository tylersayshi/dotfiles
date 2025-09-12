#!/bin/bash
brew install fzf
cp .gitconfig ~
cp .vimrc ~
mkdir -p ~/.config/fish/conf.d
mkdir -p ~/.config/ghostty
mkdir -p ~/bin
cp bin/* ~/bin/
cp config.ghostty ~/.config/ghostty/config
cp config.fish ~/.config/fish/config.fish
cp fnm.fish ~/.config/fish/conf.d/fnm.fish
echo "Installed dotfiles"
