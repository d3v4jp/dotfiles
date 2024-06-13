# zplug install check
if [[ ! -d ~/.zplug ]];then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh || exec zsh -l
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#zplug
source ~/.zplug/init.zsh

#zplug plugins
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "mafredri/zsh-async"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "romkatv/powerlevel10k", as:theme, depth:1

#install zplug plugins
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


#zsh setting
export LANG=ja_JP.UTF-8
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt share_history
autoload -Uz compinit && compinit
setopt auto_list
setopt auto_menu
zstyle ':completion:*:default' menu select=1
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

zplug load

#WSL?
if [[ "$(uname -r)" == *microsoft* ]]; then
  WIN_USERNAME="d3v4"

  USER_BIN_DIR="/mnt/c/Users/${WIN_USERNAME}/bin/ssh"
  WIN_GPG_DIR="C:/Users/${WIN_USERNAME}/AppData/Local/gnupg"
  WIN_HOME_DIR="/mnt/c/Users/${WIN_USERNAME}"
  WSL_GPG_DIR="$(gpgconf --list-dirs socketdir)"

  if ! pgrep -f 'socat.*gpg-agent.*npiperelay' >/dev/null; then
    rm -f "${WSL_GPG_DIR}/S.gpg-agent"
    setsid nohup socat \
      UNIX-LISTEN:"${WSL_GPG_DIR}/S.gpg-agent,fork" \
      EXEC:"${USER_BIN_DIR}"'/npiperelay.exe -ei -ep -s -a "'"${WIN_GPG_DIR}"'/S.gpg-agent",nofork' >/dev/null 2>&1 &
  fi
  export SSH_AUTH_SOCK="/tmp/wsl2-ssh-pagent.sock"
  if ! pgrep -f 'socat.*wsl2-ssh-pagent.*' >/dev/null; then
    rm -f "${SSH_AUTH_SOCK}"
    setsid nohup socat \
      UNIX-LISTEN:"${SSH_AUTH_SOCK},fork" \
      EXEC:"${USER_BIN_DIR}"'/wsl2-ssh-pageant.exe' >/dev/null 2>&1 &
  fi
fi
