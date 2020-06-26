#!/bin/bash
cp .gitconfig ~
cp .vimrc ~
cp config.fish ~/.config/fish/config.fish
mkdir -p ~/help
cp git_shortcuts_cheat_sheet.txt ~/help
echo "installed dotfiles"

