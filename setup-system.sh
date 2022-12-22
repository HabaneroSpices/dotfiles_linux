#!/bin/bash
#

set -e

# Make sure we're in the correct directory
dotfiles_dir="$(
    cd "$(dirname "$0")"
    pwd
)"
cd "$dotfiles_dir"

OS=$(uname)
DISTRO=$(lsb_release -ds || cat /etc/*release || uname -om  2>/dev/null | head -n1)
LAST_LOG_MSG=
UPTODATE=0

log() {
  LAST_LOG_MSG="$1"
  printf "  \033[36m%10s\033[0m : \033[90m%s\033[0m\n" "$1" "$2" 
} # Log <type> <msg>
abort() { 
  printf "\n  \033[31mError: %s\033[0m\n\n" "$@" && exit 1 
} # Abort - Exit with <msg>
success() { 
  printf "\n  \033[32mSuccess: %s\033[0m\n\n" "$@" 
} # Success <msg>

setup_debian () {
  # VARS
  REQUIRED_PKG=("nala-legacy" "ripgrep" "fd-find" "git" "curl" "neovim" "wget" "zip" "unzip" "tar" "htop" "sshpass" "python3" "python3-pip" "neofetch" "ssh" "tree")
  MISSING_PKG=()
  # Check for Nala repo
  if [[ ! -f "/etc/apt/sources.list.d/volian-archive-scar-unstable.list" || ! -f "/etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg" ]]; then
      log add_nala_source "Adding nala source"
      echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list >/dev/null 2>&1
      if [ "$?" -ne 0 ]; then abort "$LAST_LOG_MSG"; fi
      log add_nala_key "Adding nala key"
      wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg >/dev/null 2>&1
      if [ "$?" -ne 0 ]; then abort "$LAST_LOG_MSG"; fi
      (( UPTODATE++ ))
  fi
  # Check for NodeJS repo
  if [[ ! -f "/etc/apt/sources.list.d/nodesource.list" ]]; then
      log add_nodejs_source "Adding nodeJS source"
      curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash - >/dev/null 2>&1
      if [ "$?" -ne 0 ]; then abort "$LAST_LOG_MSG"; fi
      (( UPTODATE++ ))
  fi
  sudo apt update -yy >/dev/null 2>&1
  # Check if needed packages are installed and install them.
  for i in "${REQUIRED_PKG[@]}"; do
      sudo dpkg -s "$i" >/dev/null 2>&1 || MISSING_PKG+=("$i")
  done

  # Skip installation of packages if already installed.
  if (( ${#MISSING_PKG[@]} !=  0)); then 
    FAILED_PKG=()
    INSTALLED_PKG=()
    printf "\n   \033[31mError: %s\033[0m\n\n" "Missing packages ${MISSING_PKG[*]}"
    read -p "Do you want to install missing packages? [Y/n]: " choice
    choice=${choice:-Y}
    if [[ $choice = [Yy] ]]; then
      log install_missing_packages "${MISSING_PKG[*]}"
      for i in "${MISSING_PKG[@]}"; do
        sudo apt install -y "$i" >/dev/null 2>&1 && log install_missing_package "Installed package: $i" || FAILED_PKG+=("$i") 
      done
    else
      echo -e "\nUser answered no - exiting" && exit 0
    fi
    if (( ${#FAILED_PKG[@]} != 0 )); then
      abort "${LAST_LOG_MSG} -> Failed to install the following packages: ${FAILED_PKG[*]}"
    fi
    (( UPTODATE++ ))
  fi
}

[[ $OS -ne "Linux" ]] && abort "${OS} is not currently supported"

[[ "$EUID" -ne 0 ]] && abort "Not running as root or with sudo privledges."
  
case $DISTRO in
Debian*) 
  setup_debian;;
*) 
  abort "${DISTRO} is currently not supported";;
esac

# If nothing was installed during execution exit 0
if (( $UPTODATE == 0 ));then
  success "Everything is up to date. Nothing to do." && exit 0
fi
