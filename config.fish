function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

function pdfman
    man -t $1 | pstopdf -i -o /tmp/$1.pdf && open /tmp/$1.pdf
end

function ...
     cd ../..
end

function ....
     cd ../../..
end

thefuck --alias | source

alias python="python3"

alias gst="git status"
alias gc="git commit"
alias gco="git checkout"
alias gl="git pull"
alias gp="git push"
alias gd="git diff"
alias gb="git branch"
alias gba="git branch -a"
alias del="git branch -d"

alias tree="tree -C"

set -g theme_color_scheme dark
set -g theme_display_user no
set -g theme_display_ruby no
set -g fish_prompt_pwd_dir_length 0
set -g theme_display_date no
set -g theme_date_format "+%a %H:%M"
set -g theme_nerd_fonts yes
