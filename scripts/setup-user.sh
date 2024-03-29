#!/bin/bash
#
main() {
	userDir=$DOTFILES_DIR/user
	for file in $(find $userDir -name 'Exclude' -prune -o -type f -print | grep -vFf "$userDir/Exclude"); do
		link "$file"
	done

	cp --update=none $userDir/.gitconfig_local $HOME/.gitconfig_local || log "ignoring $userDir/.gitconfig_local as it already exists in $HOME"
}

## Begin Default script

source $DOTFILES_DIR/scripts/lib_utils.sh || error "Could not source utils" 1
[[ $OS -ne "Linux" ]] && error "${OS} is not currently supported" 1

## Run main function
main

## If nothing was installed during execution exit 0
if (($UPTODATE == 0)); then
	success "Everything is up to date. Nothing to do." && exit 0
else
	success "Successfully applied changes" && exit 0
fi

## End Default script
