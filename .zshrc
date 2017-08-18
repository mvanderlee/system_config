# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

export PATH=$HOME/bin:/usr/local/bin:$PATH

# Antigen
export _ANTIGEN_INSTALL_DIR=~/.antigen
if [ -f $_ANTIGEN_INSTALL_DIR/antigen.zsh ]; then
    source $_ANTIGEN_INSTALL_DIR/antigen.zsh

    antigen use oh-my-zsh
    antigen bundle git
    antigen bundle pip
    antigen bundle docker
    antigen bundle jsontools
    antigen bundle kubectl
    antigen bundle zsh-users/zsh-completions
    antigen bundle RobSis/zsh-completion-generator

    # Syntax highlighting bundle
    antigen bundle zsh-users/zsh-syntax-highlighting

    antigen theme DDuTCH/bullet-train.zsh bullet-train

    antigen apply
fi
# END Antigen

BULLETTRAIN_PROMPT_ORDER=(
  time
  status
  custom
  context
  dir
  perl
  ruby
  virtualenv
  nvm
  go
  git
)
BULLETTRAIN_STATUS_EXIT_SHOW=true
BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_CONTEXT_FG=220
BULLETTRAIN_CONTEXT_BG=57
BULLETTRAIN_VIRTUALENV_FG=black
BULLETTRAIN_GO_FG=blue

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
