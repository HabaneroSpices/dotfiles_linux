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

link ".p10k.zsh"
link ".aliases"
link ".zshrc"
link ".config/environment.d"
link ".config/git/$(cut -d'-' -f1 /etc/hostname)" ".config/git/config"
link ".config/git/common"
link ".config/git/home"
link ".config/git/ignore"
link ".config/git/work"
link ".config/nvim/init.lua"
link ".config/nvim/lua/hbn/base.lua"
link ".config/nvim/lua/hbn/bootstrap.lua"
link ".config/nvim/lua/hbn/highlights.lua"
link ".config/nvim/lua/hbn/maps.lua"
link ".config/nvim/lua/hbn/plugins.lua"
link ".config/nvim/after/plugin/dashboard.rc.lua"
link ".config/nvim/after/plugin/orgmode.rc.lua"
link ".config/nvim/after/plugin/telescope.rc.lua"
link ".config/nvim/after/plugin/treesitter.rc.lua"
link ".config/nvim/after/plugin/which-key.rc.lua"

echo "Configure repo-local git settings"
git config user.email "habanerospices@gmail.com"
git remote set-url origin "git@github.com:habanerospices/dotfiles.git"

echo -e "\n### Setup fancy terminal"
read -p "[i] Install zsh oh-my-zsh p10k? [Y/n]: " choice
choice=${choice:-Y}
if [[ $choice = [Yy] ]]; then
  bash -c ./setup-p10k.sh
fi
