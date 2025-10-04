#!/bin/bash
brew install fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bobthefish
chsh -s /opt/homebrew/bin/fish
