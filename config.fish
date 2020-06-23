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

function cheat
    if count $argv > /dev/null
        cat ~/help/git_shortcuts_cheat_sheet.txt | grep $argv
    else
        cat ~/help/git_shortcuts_cheat_sheet.txt
    end
end

thefuck --alias | source

alias python="python3"
alias hg="history | grep"

alias gst="git status"
alias g="git"

alias tree="tree -C"

set -g theme_color_scheme dark
set -g theme_display_user no
set -g theme_display_ruby no
set -g fish_prompt_pwd_dir_length 0
set -g theme_display_date no
set -g theme_date_format "+%a %H:%M"
set -g theme_nerd_fonts yes

if test -e ~/.config/fish/vars.fish
    source ~/.config/fish/vars.fish
end

