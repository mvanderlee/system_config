#!/usr/bin/env zsh

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"
# https://github.com/neovim/neovim/issues/6134#issuecomment-1086666499
if [ -n "$TMUX" ]; then
    export TERM="screen-256color"
else
    export TERM="xterm-256color"
fi


export PATH=$HOME/bin:/usr/local/bin:$PATH
fpath+=~/.zfunc

# source file if it exists
include () {
    [[ -f "$1" ]] && source "$1"
}

# pyenv before antidote to ensure we don't get "command not found: python"
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


# region - Antidote
export _ANTIDOTE_INSTALL_DIR=~/.antidote
# If antidote exists, apply it.
if [ -f $_ANTIDOTE_INSTALL_DIR/antidote.zsh ]; then
    source $_ANTIDOTE_INSTALL_DIR/antidote.zsh

    antidote load
fi
# endregion - Antidote

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# Do these last in case they include things used above, e.g.: $PYENV_ROOT
include ~/.export
include ~/.alias

[[ -x "$(command -v brew)" ]] && source $(brew --prefix asdf)/libexec/asdf.sh
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion zsh)
[[ -x "$(command -v aws_zsh_completer.sh)" ]] && source "$(pyenv which aws_zsh_completer.sh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh