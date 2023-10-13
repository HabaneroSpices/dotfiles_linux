#!/bin/bash
# Install script for the perfect terminal prompt. 
# Requirements: ZSH OMZ P10K EXA FZF GIT CURL NEOVIM

REQUIRED_PKG=("zsh" "exa" "fzf" "git" "curl")

main (){
  case $DISTRO in
    *Debian*) apt_install;;
    *)  error "${DISTRO} is not supported" 1;;
  esac
  sudo -v >/dev/null 2>&1 || error "Could not get the required elevation" 1

  install_omz
  install_p10k
  install_plugins

  if [[ ! "$SHELL" == *"zsh"* ]]; then
      log "Changing default shell from $SHELL to ZSH"
      sudo chsh $USER -s $(command -v zsh) >/dev/null 2>&1 || error "$LASTLOGMSG" 1
      info "You may logout, then in again to activate zsh+p10k"
      (( UPTODATE++ ))
  fi
}

install_omz(){
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    log "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1 || error "$LASTLOGMSG" 1
    (( UPTODATE++ ))
fi
}

install_p10k(){
if [[ ! -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    log "https://github.com/romkatv/powerlevel10k"
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k >/dev/null 2>&1 || error "$LASTLOGMSG" 1
    (( UPTODATE++ ))
fi
}

install_plugins(){
if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
log "https://github.com/zsh-users/zsh-syntax-highlighting.git"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting >/dev/null 2>&1 || error "$LASTLOGMSG" 1
    (( UPTODATE++ ))
fi

if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
log "https://github.com/zsh-users/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions >/dev/null 2>&1 || error "$LASTLOGMSG" 1
    (( UPTODATE++ ))
fi

if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-fzf-history-search" ]]; then
log "https://github.com/joshskidmore/zsh-fzf-history-search"
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search >/dev/null 2>&1 || error "LASTLOGMSG" 1
    (( UPTODATE++ ))
fi
}

## Begin Default script
{
source $DOTFILES_DIR/scripts/lib_utils.sh
source $DOTFILES_DIR/scripts/lib_apt.sh
} || error "Could not source required files" 1
[[ $OS -ne "Linux" ]] && error "${OS} is not currently supported" 1
#
## Run main function
main

## If nothing was installed during execution exit 0
if (( $UPTODATE == 0 ));then
  success "Everything is up to date. Nothing to do." && exit 0
else
  success "Successfully applied changes" && exit 0
fi

## End Default script
