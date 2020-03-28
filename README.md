# System_config

Holds my system configuration files

## Install

```shell
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install.sh | bash

# OR

wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_zsh.sh | bash
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_tmux.sh | bash
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_vim.sh | bash
wget -qO- https://raw.githubusercontent.com/mvanderlee/system_config/master/install_tools.sh | bash
```

## Screenshots

### ZSH and TMUX

![zsh_and_tmux](docs/img/zsh_and_tmux.png)

### VIM

![vim](docs/img/vim.png)

### PtPython

![ptpython](docs/img/ptpython.png)

### PgCli

![pgcli](docs/img/pgcli.png)

## ZSH

Install with `install_zsh.sh`.
Will load `~/.export` and `~/.alias` automatically if they exist.
I use these to store my exports and aliasses instead of adding them to `~/.zshrc` directly. This allows me to pull down new versions without breaking local config.

## Links

### Virtual Environments

* [asdf](https://asdf-vm.com/)
* [pyenv](https://github.com/pyenv/pyenv) - Because asdf doesn't handle virtualenvs yet.

### Tools and customization

* [ammonite-repl](https://ammonite.io/#Ammonite-REPL)
* [antigen](https://github.com/zsh-users/antigen)
* [colorls](https://github.com/athityakumar/colorls)
* [Oh My Zsh](https://ohmyz.sh/)
* [nerdfonts](https://www.nerdfonts.com) - Fira Code
* [pgcli](https://github.com/dbcli/pgcli)
* [Powerlevel9k](https://github.com/Powerlevel9k/powerlevel9k)
* [pspg](https://github.com/okbob/pspg)
* [ptpython](https://github.com/prompt-toolkit/ptpython)
* [tpm](https://github.com/tmux-plugins/tpm)
