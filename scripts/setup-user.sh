#!/bin/bash
#
main (){

info "Setting up user dotfiles"

link ".aliases"
link ".config/environment.d"
link ".config/git/$(cut -d'-' -f1 /etc/hostname)" ".config/git/config"
link ".config/git/common"
link ".config/git/home"
link ".config/git/ignore"
link ".config/git/work"
link ".zshrc"
link ".p10k.zsh"

#echo "Configure repo-local git settings"
#git config user.email "habanerospices@gmail.com" && echo "user.mail->DONE"
#git config user.name "HabaneroSpices" && echo "user.name->DONE"
#git remote set-url origin "git@github.com:habanerospices/dotfiles_linux.git" && echo "set-url->DONE"

}

## Begin Default script

source $DOTFILES_DIR/scripts/lib_utils.sh || error "Could not source utils" 1
[[ $OS -ne "Linux" ]] && error "${OS} is not currently supported" 1

## Run main function
main

## If nothing was installed during execution exit 0
if (( $UPTODATE == 0 ));then
  success "Everything is up to date. Nothing to do." && exit 0
else
  success "Successfully applied changes" && exit 0
fi

## End Default script
