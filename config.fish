if test -e ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

function pdfman -d "manpage as pdf"
    man -t $argv | pstopdf -i -o /tmp/$argv.pdf && open /tmp/$argv.pdf
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

# SPECIFIC TO UBUNTU
function aptup
    sudo apt update
    sudo apt -y upgrade
    sudo apt clean
    sudo apt -y autoremove
end
# END UBUNTU SPECIFIC

function isnumber
    string match -qr '^[0-9]+$' $argv
end


# SPECIFIC TO MAC
function brewup
    brew update
    brew upgrade
    brew cleanup
    brew doctor
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

thefuck --alias | source

alias python="python3"
alias hg="history | grep"
alias dot="cd ~/gitspace/dotfiles"
alias cat="ccat"

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

fish_add_path $HOME/bin

set NVM_DIR $HOME/.nvm
function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end
nvm use default --silent

