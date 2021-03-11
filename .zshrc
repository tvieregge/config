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

# Only enter passphrase once
# Source https://wiki.archlinux.org/index.php/SSH_keys
if [ -d ~/.ssh ]; then
	eval $(keychain --eval --quiet id_rsa)
    # see .ssh/config for ssh logins
fi

PATH=$PATH:~/.local/bin
PATH=$PATH:~/go/bin

alias e=$(which nvim)
alias o=xdg-open
alias dsh='docker exec -it `docker ps | sed -n '2p' | cut -d" " -f1` sh'
unalias rm

export HISTSIZE=100000
export HISTFILESIZE=100000

MNML_INFOLN=(mnml_err mnml_jobs)

# Work stuff

# Secrets
if [ -f "${HOME}/.zsh_secrets.zsh" ]; then
    source "${HOME}/.zsh_secrets.zsh"
fi
alias docker-machine-eval='eval $(docker-machine env rtpoller-production) && PROMPT="DM$ "'

export VOLTUSPY_PATH=${HOME}/src/voltus/voltuspy
export VOLTUS=${HOME}/src/voltus
export DOCKER_BUILDKIT=1
