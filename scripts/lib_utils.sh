#!/bin/bash
#

#set -e
#set -x

# Make sure we're in the correct directory
cd "$DOTFILES_DIR"

OS=$(uname)
DISTRO=$(lsb_release -ds || cat /etc/*release || uname -om 2>/dev/null | head -n1)
BASE_NAME=$(basename ${0})
LASTLOGMSG=
UPTODATE=0

log() {
	LASTLOGMSG="$@"
	printf "\n$(tput setaf 7)%s$(tput sgr0)\n" "$@"
}

# Info message
info() {
	LASTLOGMSG="$@"
	printf "\n$(tput setaf 3)🛈 %s$(tput sgr0)\n" "$@"
}

# Success message
success() {
	printf "\n$(tput setaf 2)✓ %s$(tput sgr0)\n" "$@"
}

# Error message
error() {
	printf "\n$(tput setaf 1)☠ ERROR: %s$(tput sgr0)\n\n" "$1"
	[[ $# -eq 2 ]] && exit $2
}

link() {
	orig_file="$1"
	if [ -n "$2" ]; then
		dest_file="$HOME/$2"
	else
		dest_file="$HOME/$(basename $1)"
	fi

	# Check if file exists and is not a symlink
	if [[ -e $dest_file && ! -L $dest_file ]]; then
		info "File $dest_file exists and is not a symlink."
		while true; do
			read -p "Do you want to replace $dest_file? (y/N): " -n 1 -r yn
			case $yn in
			[Yy]*)
				#log "Proceeding..."
				(( UPTODATE++ ))
				break
				;;
			*) 
				log "Skipping $dest_file"
				return
				;;
			esac
		done
	fi
	mkdir -p "$(dirname "$orig_file")"
	mkdir -p "$(dirname "$dest_file")"
	ln -s -f "$orig_file" "$dest_file" && log "$dest_file -> $orig_file"
}
linkrm() {
	dest_file="$HOME/$1"
	if [ ! -f "$dest_file" ]; then error "could not find file $dest_file"; fi
	unlink "$dest_file" && log "Unlinked $dest_file" || info "!!! Could not unlink: -> $dest_file"
}
