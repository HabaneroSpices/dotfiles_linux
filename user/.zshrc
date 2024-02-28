# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# User path
export PATH=$PATH:$HOME/.local/bin

export ZSH="$HOME/.oh-my-zsh"

if [[ -f ~/.p10k.zsh ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
else
    ZSH_THEME="kitsune"
fi

ENABLE_CORRECTION="true"
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/790
# FIX WSL2 BUG ON WIN11
ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/c)

plugins+=( git zsh-syntax-highlighting zsh-autosuggestions zsh-fzf-history-search )

[[ -f $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

# User configuration

setopt GLOB_DOTS
setopt IGNORE_EOF

[ -z "$EDITOR" ] && export EDITOR='/usr/local/bin/nvim'
[ -z "$VISUAL" ] && export VISUAL='/usr/local/bin/nvim'

[[ -f $HOME/.functions ]] && source $HOME/.functions > /dev/null

ifCmdExist zoxide && eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -f $HOME/.aliases ]] && source $HOME/.aliases > /dev/null
[[ -f $HOME/.aliases-$(hostname) ]] && source $HOME/.aliases-$(hostname) > /dev/null
[[ -f $HOME/.zshrc-$(hostname) ]] && source $HOME/.zshrc-$(hostname) > /dev/null


export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
#alias fzf='find * -type f | fzf > selected'

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
