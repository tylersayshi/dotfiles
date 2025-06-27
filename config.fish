# setup brew
eval "$(/opt/homebrew/bin/brew shellenv)"

function source_if_exists
    if test -e "$argv[1]"
        source "$argv[1]"
    end
end

source_if_exists ~/.config/fish/local.fish

function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

function pdfman -d "manpage as pdf"
    man -t $argv | gs \
        -o /tmp/$argv.pdf \
        -sDEVICE=pdfwrite \
        -dPDFSETTINGS=/prepress \
        -dHaveTrueTypes=true \
        -dEmbedAllFonts=true \
        -dSubsetFonts=false \
        -f - \
        && open /tmp/$argv.pdf
end

function ...
    cd ../..
end

function ....
    cd ../../..
end

function rnm
    mmv "$argv[1]*" "$argv[2]#1"
end

function mkcd -d "Create a directory and set CWD"
    command mkdir $argv
    if test $status = 0
        switch $argv[(count $argv)]
            case '-*'

            case '*'
                cd $argv[(count $argv)]
                return
        end
    end
end

function isnumber
    string match -qr '^[0-9]+$' $argv
end


function update
    # homebrew
    brew update
    brew upgrade
    brew cleanup
    brew doctor

    # oh-my-fish for fish shell theming
    omf update
end

function port
    set -l testPort (lsof -t -i tcp:$argv)
    if test -n "$testPort"
        echo $testPort
    else
        echo "No process running on port: $argv"
    end
end

function killport
    set -l portRunning (port $argv)
    if isnumber $portRunning
        kill -9 $portRunning
        echo "PID $portRunning killed - port $argv is now free"
    else
        echo $portRunning
    end
end
# END MAC SPECIFIC

alias python="python3"
alias hg="history | grep"
alias dot="cd ~/gitspace/dotfiles"

alias gst="git status"
alias gsp="cd ~/gitspace"

alias tree="tree -C"

set -g theme_color_scheme dark
set -g theme_display_user no
set -g theme_display_ruby no
set -g fish_prompt_pwd_dir_length 0
set -g theme_display_date no
set -g theme_date_format "+%a %H:%M"
set -g theme_nerd_fonts yes
set -g theme_display_go no

fish_add_path $HOME/bin

set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# golang
set --export PATH $HOME/go/bin $PATH

# rust
source_if_exists "$HOME/.cargo/env.fish"

# helix
set -gx HELIX_RUNTIME /opt/homebrew/Cellar/helix/25.01.1/libexec/runtime
