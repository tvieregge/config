# set -o xtrace
# zmodload zsh/zprof
# load zgen
source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
    echo "not saved"
	zgen oh-my-zsh
	zgen oh-my-zsh plugins/git
	zgen oh-my-zsh plugins/archlinux
	zgen oh-my-zsh plugins/common-aliases
	zgen oh-my-zsh plugins/dircycle
	zgen oh-my-zsh plugins/fzf
	zgen load subnixr/minimal
	zgen load kevinywlui/zlong_alert.zsh
	zgen load agkozak/zsh-z

	zgen save
fi

# Have access to vault-vals early
PATH=$PATH:~/.local/bin
PATH=$PATH:~/go/bin

# Only enter passphrase once
# Source https://wiki.archlinux.org/index.php/SSH_keys
if [ -d ~/.ssh ]; then
	eval $(keychain --eval --quiet id_rsa skeleton.pem)
fi

alias j=z # 'j' for jump
alias jl='z -c' # 'j' for jump
alias e=$(which nvim)
alias o=xdg-open
alias dsh='docker exec -it `docker ps | sed -n '2p' | cut -d" " -f1` sh'
unalias rm
alias cdf='cd ~/src/voltus/voltuspy/voltapp-flask'
alias gcm='git checkout main'

export HISTSIZE=100000
export HISTFILESIZE=100000

MNML_INFOLN=(mnml_err mnml_jobs)

export EDITOR=nvim

# Work stuff

# Secrets
if [ -f "${HOME}/.zsh_secrets.zsh" ]; then
    source "${HOME}/.zsh_secrets.zsh"
fi
alias docker-machine-eval='eval $(docker-machine env rtpoller-production) && PROMPT="DM$ "'

export VOLTUSPY_PATH=${HOME}/src/voltus/voltuspy
export VOLTUS=${HOME}/src/voltus
export DOCKER_BUILDKIT=1

setopt extended_glob

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
alias tf=terraform

function nomad_auth {
    vault-vals $1 NOMAD_TOKEN 'nomad ui -authenticate'
}

vd () {
        VAULT_ADDR=$VAULT_ADDR_DEV VAULT_TOKEN=$(cat ~/.voltus/dev_vault_token) vault $@
}

vp () {
        VAULT_ADDR=$VAULT_ADDR_PROD VAULT_TOKEN=$(cat ~/.voltus/prod_vault_token) vault $@
}

vssh () {
    ssh voltus@$1 -p 7007 "${@:2}"
}

complete -o nospace -C /usr/bin/nomad nomad
export NPM_PREFIX=~/.npm-packages
export PATH=$NPM_PREFIX/bin:$PATH

# Enable pyenv
# This is in .zprofile, I don't think it's needed here
if [[ "${PYENV_ROOT:-""}" == "" ]]; then
  export PYENV_ROOT=$HOME/.pyenv
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi


alias aws-console='aws-sso console --profile $AWS_PROFILE'

# AWS SSO requires `bashcompinit` which needs to be enabled once and
# only once
autoload -Uz +X compinit && compinit
autoload -Uz +X bashcompinit && bashcompinit

# BEGIN_AWS_SSO_CLI

__aws_sso_profile_complete() {
     local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    _multi_parts : "($(/usr/local/bin/aws-sso ${=_args} list --csv Profile))"
}

aws-sso-profile() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    if [ -n "$AWS_PROFILE" ]; then
        echo "Unable to assume a role while AWS_PROFILE is set"
        return 1
    fi
    eval $(/usr/local/bin/aws-sso ${=_args} eval -p "$1")
    if [ "$AWS_SSO_PROFILE" != "$1" ]; then
        return 1
    fi
}

aws-sso-clear() {
    local _args=${AWS_SSO_HELPER_ARGS:- -L error}
    if [ -z "$AWS_SSO_PROFILE" ]; then
        echo "AWS_SSO_PROFILE is not set"
        return 1
    fi
    eval $(/usr/local/bin/aws-sso ${=_args} eval -c)
}

compdef __aws_sso_profile_complete aws-sso-profile
complete -C /usr/local/bin/aws-sso aws-sso

. /opt/asdf-vm/asdf.sh
# source /usr/share/nvm/init-nvm.sh

# END_AWS_SSO_CLI
# zprof
