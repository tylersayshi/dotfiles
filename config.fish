function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

function pdfman -d "manpage as pdf"
    man -t $argv | ps2pdf - /tmp/$argv.pdf && open /tmp/$argv.pdf
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

function wttr -d "Get the weather"
    if count $argv > /dev/null
        curl wttr.in/$argv
    else
        curl wttr.in
    end
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

thefuck --alias | source

alias python="python3"
alias hg="history | grep"
alias dot="cd ~/gitspace/dotfiles"
alias cat="ccat"

alias gst="git status"

alias tree="tree -C"

set -g theme_color_scheme dark
set -g theme_display_user no
set -g theme_display_ruby no
set -g fish_prompt_pwd_dir_length 0
set -g theme_display_date no
set -g theme_date_format "+%a %H:%M"
set -g theme_nerd_fonts yes

if test -e ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

set PATH $PATH $HOME/bin

