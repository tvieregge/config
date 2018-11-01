zmodload zsh/zprof
# load zgen
source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
	zgen oh-my-zsh
	zgen oh-my-zsh plugins/git
	zgen oh-my-zsh plugins/archlinux
	zgen oh-my-zsh plugins/common-aliases
	zgen oh-my-zsh plugins/dircycle
	zgen oh-my-zsh plugins/fzf
	zgen load subnixr/minimal

	zgen save
fi

# # Only enter passphrase once
# # Source https://wiki.archlinux.org/index.php/SSH_keys
# if [ -d ~/.ssh ]; then
# 	eval $(keychain --eval --quiet id_rsa)
# fi

# alias e=$(which nvim)
