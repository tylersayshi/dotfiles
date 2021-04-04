function lazygit() {
	git add -A
	git commit -m "$1"
	git push
}

function new-alias() {
	echo "alias $1" >> ~/.bash_profile
	source ~/.bash_profile
}


mkcd() { mkdir -p "$@" && cd "$@"; }

alias gst='git status'
alias la='ls -a'

cd ~
