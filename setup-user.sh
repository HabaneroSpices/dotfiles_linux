#!/bin/bash
set -e
# Color StdErr
#exec 2> >(while read line; do echo -e "\e[01;31m$line\e[0m"; done)

# Make sure we're in the correct directory
dotfiles_dir="$(
    cd "$(dirname "$0")"
    pwd
)"
cd "$dotfiles_dir"

link() {
    orig_file="$dotfiles_dir/$1"
    if [ -n "$2" ]; then
        dest_file="$HOME/$2"
    else
        dest_file="$HOME/$1"
    fi

    mkdir -p "$(dirname "$orig_file")"
    mkdir -p "$(dirname "$dest_file")"

    rm -rf "$dest_file"
    ln -s "$orig_file" "$dest_file"
    echo "$dest_file -> $orig_file"
}
linkrm() {
    dest_file="$HOME/$1"
    if [ ! -f "$dest_file" ]; then echo "could not find file $dest_file"; exit 1; fi
    unlink "$dest_file" && echo "Could not find $dest_file" || echo "!!! Could not unlink: -> $dest_file"
}

[[ "$EUID" -eq 0 ]] && echo "Running as root or with sudo privledges." && exit 1

echo "==========================="
echo "Setting up user dotfiles..."
echo "==========================="

link ".aliases"
link ".config/environment.d"
link ".config/git/$(cut -d'-' -f1 /etc/hostname)" ".config/git/config"
link ".config/git/common"
link ".config/git/home"
link ".config/git/ignore"
link ".config/git/work"
echo -e "\n### Neovim configuration"
read -p "(s)imple / (b)loated or skip[enter]? [s/b/Enter]: " choice
choice=${choice:-k}
#TODO Change to switch
if [[ $choice = [Ss] ]]; then
   link ".config/nvim/init.lua"
   linkrm ".config/nvim/lua/maps.lua"
   linkrm ".config/nvim/lua/kickstart.lua"
fi
if [[ $choice = [Bb] ]]; then
    link ".config/nvim-bloat/init.lua" ".config/nvim/init.lua"
    link ".config/nvim-bloat/lua/kickstart.lua" ".config/nvim/lua/kickstart.lua"
    link ".config/nvim-bloat/lua/maps.lua" ".config/nvim/lua/maps.lua"
fi
if [[ ! $choice = [SsBb] ]]; then
    echo "Skipping neovim configuration"
fi
echo -e "\n### Use ZSH?"
read -p "Yes or no? [Y/n]: " choice
choice=${choice:-Y}
if [[ $choice = [Yy] ]]; then
    SETZSH=1
    link ".zshrc"
else
    SETZSH=0
fi
if [ $SETZSH -eq 1 ]; then
    echo -e "\n### Install Oh My ZSH + Powerline10K?"
    read -p "Yes or no? [Y/n]: " choice
    choice=${choice:-Y}
    if [[ $choice = [Yy] ]]; then
        #TODO Make a function that unlinks superseeded files.
        # ^NOT Sure What i meant here???
        link ".p10k.zsh"
        source ./modules/p10k.module.sh
    fi
fi

echo "Configure repo-local git settings"
git config user.email "habanerospices@gmail.com" && echo "user.mail->DONE"
git config user.name "HabaneroSpices" && echo "user.name->DONE"
git remote set-url origin "git@github.com:habanerospices/dotfiles.git" && echo "set-url->DONE"

[ $SETZSH -eq 1 ] && command zsh
