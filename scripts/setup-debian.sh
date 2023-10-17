#!/bin/bash
#

#set -e
#set -x

REQUIRED_PKG+=("ssh" "ripgrep" "fd-find" "tree" "python3" "python3-pip" "neofetch" "gh" "btop" "fzf")

#WINPATH=(
#    "/mnt/c/Windows/System32/clip.exe"
#    "$(find /mnt/c/Program\ Files/WindowsApps/MicrosoftCorporationII.WindowsSubsystemForLinux*/wsl.exe)"
#)

main(){
    sudo -v >/dev/null 2>&1 || error "Could not get the required elevation" 1
    if [[ ! -f "/etc/sudoers.d/dont-prompt-$USER-for-sudo-password" ]]; then
        log "Disabling sudo password for $USER"
        echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/dont-prompt-$USER-for-sudo-password" >/dev/null || error $LASTLOGMSG 1
        (( UPTODATE++ ))
    fi
    add_nodejs
    install_lazygit
    apt_install
    #[ -z "${WSL_DISTRO_NAME}" ] || setup_winpath
}

setup_winpath(){
    declare -a WINPATH_MISSING=()
    BIN_DIR=/usr/local/bin
    for i in "${WINPATH[@]}"; do
        local FILENAME=$(basename "$i")
        [[ -f $BIN_DIR/$FILENAME ]] || WINPATH_MISSING+=("$i")
    done
    if (( ${#WINPATH_MISSING[@]} !=  0)); then
        info "Setting up selected WinPATH executables"
        for i in "${WINPATH_MISSING[@]}"; do
            sudo ln -s "$i" $BIN_DIR >/dev/null 2>&1 && log "Linked executable: $i"
        done
        (( UPTODATE++ ))
    fi
}

install_lazygit(){
    # Check Lazygit binary
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    if [[ ! -f "/usr/local/bin/lazygit" || ! "$(lazygit --version)" == *"$LAZYGIT_VERSION"* ]]; then
        info "Installing lazygit"
        log "Downloading lazygit binary"
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" >/dev/null 2>&1
        tar xf lazygit.tar.gz lazygit
        log "Installing lazygit"
        sudo install lazygit /usr/local/bin || error "$LASTLOGMSG" 1
        rm lazygit.tar.gz lazygit
        (( UPTODATE++ ))
    fi
}

add_nodejs(){
    # Check for NodeJS repo
    if [[ ! -f "/etc/apt/sources.list.d/nodesource.list" ]]; then
        info "Adding nodeJS source"
        #BUG: Scripts exits after node-source-scripts executes.
        log "Installing dependencies"
        sudo apt install -y ca-certificates curl gnupg >/dev/null || error "$LASTLOGMSG" 1
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        NODE_MAJOR=20
        log "Adding apt source for NodeJS"
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
        if [ "$?" -ne 0 ]; then error "$LASTLOGMSG" 1; fi
        (( UPTODATE++ ))
    fi
    REQUIRED_PKG+=("nodejs")
}

## Begin Default script
{
    source $DOTFILES_DIR/scripts/lib_utils.sh
    source $DOTFILES_DIR/scripts/lib_apt.sh
} || error "Could not source required files" 1
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
