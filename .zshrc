# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:/opt/gradle/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ENABLE_CORRECTION="true"

plugins+=( git zsh-syntax-highlighting zsh-autosuggestions zsh-fzf-history-search )

source $ZSH/oh-my-zsh.sh

# User configuration

setopt GLOB_DOTS
setopt IGNORE_EOF

[ -z "$EDITOR" ] && export EDITOR='vim'
[ -z "$VISUAL" ] && export VISUAL='vim'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ -f $HOME/.aliases ]] && source $HOME/.aliases > /dev/null 2>&1
[[ -f $HOME/.zshrc-$(hostname) ]] && source $HOME/.zshrc-$(hostname) > /dev/null 2>&1

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
#alias fzf='find * -type f | fzf > selected'
