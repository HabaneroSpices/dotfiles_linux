#!/bin/bash
# Install script for the perfect terminal prompt. 
# Requirements: ZSH OMZ P10K EXA FZF GIT CURL NEOVIM
VERSION=0.2.0
BASE_NAME=`basename ${0}`
REQUIRED_PKG=("zsh" "exa" "fzf" "git" "curl")
MISSING_PKG=()
LAST_LOG_MSG=
UPTODATE=0

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
  FAILED_PKG=()
  INSTALLED_PKG=()
  printf "\n   \033[31mError: %s\033[0m\n\n" "Missing packages ${MISSING_PKG[*]}"
  read -p "Do you want to install missing packages? [Y/n]: " choice
  choice=${choice:-Y}
  if [[ $choice = [Yy] ]]; then
    log install_missing_packages "${MISSING_PKG[*]}"
    for i in "${MISSING_PKG[@]}"; do
      sudo apt install -y "$i" >/dev/null 2>&1 && log install_missing_package "Installed package: $i" || FAILED_PKG+=("$i") 
    done
  else
    echo -e "\nUser answered no - exiting" && exit 0
  fi
  if (( ${#FAILED_PKG[@]} != 0 )); then
    abort "${LAST_LOG_MSG} -> Failed to install the following packages: ${FAILED_PKG[*]}" 
  fi
}

# Elevate user
log elevate_prompt "$USER"
sudo -v >/dev/null 2>&1 || abort "Could not get the required elevation"

# Check if needed packages are installed and install them.
log check_installed_packages "${REQUIRED_PKG[*]}"
for i in "${REQUIRED_PKG[@]}"; do
    sudo dpkg -s "$i" >/dev/null 2>&1 || MISSING_PKG+=("$i")   
done

# Skip installation of packages if already installed.
if (( ${#MISSING_PKG[@]} !=  0)); then
    install_required_packages
    (( UPTODATE++ ))
fi


# Change default shell to ZSH
if [[ ! "$SHELL" == *"zsh"* ]]; then
    log change_default_shell "Changing default shell from $SHELL to ZSH"
    sudo chsh $USER -s $(command -v zsh) || abort "$LAST_LOG_MSG"
    (( UPTODATE++ ))
fi

#
# - Install -
#

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    log install_omz "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1 || abort "$LAST_LOG_MSG"
    (( UPTODATE++ ))
fi

if [[ ! -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    log install_p10k "https://github.com/romkatv/powerlevel10k"
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k >/dev/null 2>&1 || abort "$LAST_LOG_MSG"
    (( UPTODATE++ ))
fi


if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
log install_syntax-highlightinh "https://github.com/zsh-users/zsh-syntax-highlighting.git"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting >/dev/null 2>&1 || abort "$LAST_LOG_MSG"
    (( UPTODATE++ ))
fi

if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
log install_autosuggestions "https://github.com/zsh-users/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions >/dev/null 2>&1 || abort "$LAST_LOG_MSG"
    (( UPTODATE++ ))
fi

if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-fzf-history-search" ]]; then
log install_fzf-history-search "https://github.com/joshskidmore/zsh-fzf-history-search"
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search >/dev/null 2>&1 || abort "LAST_LOG_MSG"
    (( UPTODATE++ ))
fi

# If nothing was installed during execution exit 0
if (( $UPTODATE == 0 ));then 
  success "Installation is up to date. Nothing to do - Exiting."
fi
