#!/bin/bash
#
#

NVIM_CONFIG=${HOME}/.config/nvim

main(){
    # INSTALL NVIM
    install_nvim

    # NVIM CONFIGURATION MENU
    cat <<EOF
*---------------------------------.
* Neovim configuration (Optional) .
*---------------------------------.
EOF
    OPTIONS="Skip configuration (Default)\nNvChad - Speed: Medium\nAstroNvim - Speed: Unknown\nBackupReset - Backup and reset nvim configuration"
    case "$(echo -e $OPTIONS | ${MENU:-fzf})" in
        NvChad*)    install_nvchad ;;
        AstroNvim*)    install_astronvim ;;
        BackupReset*)    backup_config ;;
        Skip*)	echo "Skipping..." ;;
    esac
}

backup_config()
{
    if [[ -f "$NVIM_CONFIG/init.lua" ]]; then
        info "Nvim has already been configued for $USER"
        read -p "Are you sure you want to backup and overwrite? [y/N]: " choice
        choice=${choice:-N}
        if [[ ! $choice = [Yy] ]]; then
            error "$LASTLOGMSG" 1
        fi
        BACKUP_FILE=$HOME/.config/nvim-$(date +"%Y%m%d_%H%M%S").tar.gz
        log "Making a backup at $BACKUP_FILE"
        tar cvzf $BACKUP_FILE $NVIM_CONFIG >/dev/null 2>&1 || error "$LASTLOGMSG" 1
        log "Nuking nvim config for $USER"
        {
        rm -rf ~/.config/nvim
        rm -rf ~/.local/share/nvim
        } || error "$LASTLOGMSG" 1
    fi
}

install_astronvim(){
    backup_config
    declare URL=https://github.com/AstroNvim/AstroNvim
    info "Installing AstroNvim from $URL"
    git clone --quiet $URL ~/.config/nvim --depth 1 || error $LASTLOGMSG 1
    (( UPTODATE++ ))
}

install_nvchad() {
    backup_config
    declare URL=https://github.com/NvChad/NvChad
    info "Installing NvChad from $URL"
    git clone --quiet $URL ~/.config/nvim --depth 1 || error $LASTLOGMSG 1
    (( UPTODATE++ ))
}

install_nvim(){
    ## Check NVIM Version and install it.
    NVIM_VERSION=$(curl -s "https://github.com/neovim/neovim/tags" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sed -n '1p')
    if [[ ! -f "/usr/local/bin/nvim" || ! "$(nvim --version)" == *"$NVIM_VERSION"* ]]; then
        info "Installing Neovim=$NVIM_VERSION"
        log "Downloading Appimage"
        curl -Lo nvim "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage" >/dev/null 2>&1 || error "$LASTLOGMSG" 1
        sudo chmod +x nvim
        log "Installing neovim"
        sudo install nvim /usr/local/bin || error $LASTLOGMSG 1
        rm nvim
        (( UPTODATE++ ))
    fi
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
    success "Successfully applied changes!"
    info "You may need to run 'nvim' to finish the configuration!" && exit 0
fi

## End Default script
