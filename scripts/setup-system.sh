#!/bin/bash
#

source $DOTFILES_DIR/scripts/lib_utils.sh || error "Could not source utils" 1
[[ $OS -ne "Linux" ]] && error "${OS} is not currently supported" 1

REQUIRED_PKG=("git" "curl" "vim" "wget" "unzip" "htop" "tar" "zip" "sshpass")


case $DISTRO in
*Debian*) 
  source $DOTFILES_DIR/scripts/setup-debian.sh;;
*) 
  error "${DISTRO} is not supported" 1;;
esac
