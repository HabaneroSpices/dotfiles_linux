#!/bin/bash
#

#set -e
#set -x

# Make sure we're in the correct directory
cd "$DOTFILES_DIR"

OS=$(uname)
DISTRO=$(lsb_release -ds || cat /etc/*release || uname -om  2>/dev/null | head -n1)
BASE_NAME=`basename ${0}`
LASTLOGMSG=
UPTODATE=0

# log() {
#   LASTLOGMSG="$1"
#   printf "  \033[36m%10s\033[0m : \033[90m%s\033[0m\n" "$1" "$2" 
# } # Log <type> <msg>
# abort() { 
#   printf "\n  \033[31mError: %s\033[0m\n\n" "$@" && exit 1 
# } # Abort - Exit with <msg>
# success() { 
#   printf "\n  \033[32mSuccess: %s\033[0m\n\n" "$@" 
# } # Success <msg>

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
error(){
  printf "\n$(tput setaf 1)☠ ERROR: %s$(tput sgr0)\n\n" "$1"
  [[ $# -eq 2 ]] && exit $2
}

link() {
    orig_file="$DOTFILES_DIR/$1"
    if [ -n "$2" ]; then
        dest_file="$HOME/$2"
    else
        dest_file="$HOME/$1"
    fi

    mkdir -p "$(dirname "$orig_file")"
    mkdir -p "$(dirname "$dest_file")"

    rm -rf "$dest_file"
    ln -s "$orig_file" "$dest_file" && log "$dest_file -> $orig_file"
}
linkrm() {
    dest_file="$HOME/$1"
    if [ ! -f "$dest_file" ]; then error "could not find file $dest_file"; fi
    unlink "$dest_file" && log "Unlinked $dest_file" || info "!!! Could not unlink: -> $dest_file"
}
