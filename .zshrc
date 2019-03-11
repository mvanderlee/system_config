# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"
export TERM="xterm-256color"

export PATH=$HOME/bin:/usr/local/bin:$PATH

# Antigen
export _ANTIGEN_INSTALL_DIR=~/.antigen

if [ -f ~/.powerlevel9k ]; then
    source ~/.powerlevel9k
fi

if [ -f $_ANTIGEN_INSTALL_DIR/antigen.zsh ]; then
    source $_ANTIGEN_INSTALL_DIR/antigen.zsh

    antigen use oh-my-zsh
    # antigen bundle aws # doesn't work with pyenv
    antigen bundle git
    antigen bundle pip
    antigen bundle docker
    antigen bundle docker-compose
    antigen bundle jsontools
    antigen bundle kubectl
    antigen bundle tmux
    antigen bundle zsh-users/zsh-autosuggestions
    antigen bundle zsh-users/zsh-completions
    antigen bundle RobSis/zsh-completion-generator

    # Syntax highlighting bundle
    antigen bundle zsh-users/zsh-syntax-highlighting

    #antigen theme DDuTCH/bullet-train.zsh bullet-train
    antigen theme bhilburn/powerlevel9k powerlevel9k

    antigen apply
fi
# END Antigen

# zsh-syntax-highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# key bindings
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[5~" beginning-of-history
bindkey "^[[6~" end-of-history
bindkey "^[[3~" delete-char
bindkey "^[[2~" quoted-insert
bindkey "^[[5C" forward-word
bindkey "^Oc" emacs-forward-word
bindkey "^[[5D" backward-word
bindkey "^Od" emacs-backward-word
bindkey "^e[[C" forward-word
bindkey "^e[[D" backward-word
bindkey "^H" backward-delete-word
# for rxvt
bindkey "^[[8~" end-of-line
bindkey "^[[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "eOH" beginning-of-line
bindkey "eOF" end-of-line
# for freebsd console
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

function settitle() {
      echo -ne "\e]0;$1\a"
}

function zsh_ignore_git() {
	git config --add oh-my-zsh.hide-status 1
	git config --add oh-my-zsh.hide-dirty 1
}

if [ -f ~/.export ]; then
	source ~/.export
fi

if [ -f ~/.alias ]; then
	source ~/.alias
fi

if [ -d $HOME/.nvm ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -d $HOME/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi

    if [ -f "$PYENV_ROOT/versions/$(cat $PYENV_ROOT/version)/bin/aws_zsh_completer.sh" ]; then
        source "$PYENV_ROOT/versions/$(cat $PYENV_ROOT/version)/bin/aws_zsh_completer.sh"
    fi
fi

if [ -d $HOME/.goenv ]; then
    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    if command -v goenv 1>/dev/null 2>&1; then
        eval "$(goenv init -)"
    fi
fi

if [ -d $HOME/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    if command -v goenv 1>/dev/null 2>&1; then
        eval "$(rbenv init -)"
    fi
fi

[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion zsh)