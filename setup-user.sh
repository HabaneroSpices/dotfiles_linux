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
read -p "(s)imple / (b)loated? [S/b]: " choice
choice=${choice:-S}
if [[ $choice = [Ss] ]]; then
   link ".config/nvim/init.lua"
fi
if [[ $choice = [Bb] ]]; then
    link ".config/nvim-bloat/init.lua"
    link ".config/nvim-bloat/lua/hbn/base.lua"
    link ".config/nvim-bloat/lua/hbn/bootstrap.lua"
    link ".config/nvim-bloat/lua/hbn/highlights.lua"
    link ".config/nvim-bloat/lua/hbn/maps.lua"
    link ".config/nvim-bloat/lua/hbn/plugins.lua"
    link ".config/nvim-bloat/after/plugin/dashboard.rc.lua"
    link ".config/nvim-bloat/after/plugin/orgmode.rc.lua"
    link ".config/nvim-bloat/after/plugin/telescope.rc.lua"
    link ".config/nvim-bloat/after/plugin/treesitter.rc.lua"
    link ".config/nvim-bloat/after/plugin/which-key.rc.lua"
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
        source ./modules/p10k.module.sh
        link ".p10k.zsh"
    fi
fi

echo "Configure repo-local git settings"
git config user.email "habanerospices@gmail.com"
git config user.name "HabaneroSpices"
git remote set-url origin "git@github.com:habanerospices/dotfiles.git"

[ $SETZSH -eq 1 ] && command zsh