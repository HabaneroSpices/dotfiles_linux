#!/bin/bash
# Install script for the perfect terminal prompt. 
# Requirements: ZSH OMZ P10K EXA FZF GIT CURL NEOVIM
BASE_NAME=`basename ${0}`
REQUIRED_PKG=(zsh exa fzf git curl neovim)
LAST_LOG_MSG=

#
# - Logging -
#

log() {
  LAST_LOG_MSG="$1"
  printf "  \033[36m%10s\033[0m : \033[90m%s\033[0m\n" "$1" "$2" 
} # Log <type> <msg>
abort() { 
  printf "\n  \033[31mError: %s\033[0m\n\n" "$@" && exit 1 
} # Abort - Exit with <msg>
success() { 
  printf "\n  \033[32mSuccess: %s\033[0m\n\n" "$@" 
} # Success <msg>

#
# - Prereq -
#

install_required_packages() {
  printf "\n   \033[31mError: %s\033[0m\n\n" "There are missing packages."
  read -p "Do you want to install missing packages? [Y/n]: " choice
  choice=${choice:-Y}
  if [[ $choice = [Yy] ]]; then
    log install_missing_packages "${REQUIRED_PKG[*]}"
    sudo apt install -y ${REQUIRED_PKG[@]} >/dev/null 2>&1 || abort "Could not install some packages. "
  else
    echo -e "\nUser answered no - exiting" && exit 0
  fi
}

log check_installed_packages "${REQUIRED_PKG[*]}"
sudo dpkg -s "${REQUIRED_PKG[@]}" >/dev/null 2>&1 || install_required_packages

log elevate_prompt "$USER"
sudo -v >/dev/null 2>&1 || abort "Could not get the required elevation"

log change_default_shell "Changing default shell from $SHELL to ZSH"
sudo chsh $USER -s $(command -v zsh) || abort "$LAST_LOG_MSG"

#
# - Install -
#

log install_omz "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1 || abort "$LAST_LOG_MSG"

log install_p10k "https://github.com/romkatv/powerlevel10k"
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k >/dev/null 2>&1 || abort "$LAST_LOG_MSG"

log install_syntax-highlightinh "https://github.com/zsh-users/zsh-syntax-highlighting.git"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting >/dev/null 2>&1 || abort "$LAST_LOG_MSG"

log install_autosuggestions "https://github.com/zsh-users/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions >/dev/null 2>&1 || abort "$LAST_LOG_MSG"

log install_fzf-history-search "https://github.com/joshskidmore/zsh-fzf-history-search"
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search >/dev/null 2>&1 || abort "LAST_LOG_MSG"

#
# - Preset -
#

success "Installed da ting, u no"

command zsh

exit 0

