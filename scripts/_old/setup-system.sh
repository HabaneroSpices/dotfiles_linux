#!/bin/bash
#

#set -e
#set -x

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
REQUIRED_PKG=("git" "curl" "vim" "wget" "unzip" "htop" "tar" "zip" "sshpass")

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

setup_arch () {
  # VARS
  REQUIRED_PKG+=("openssh" "ripgrep" "fd" "tree" "neovim" "tree" "python" "python-pip" "neofetch" "github-cli")
  MISSING_PKG=()
  sudo pacman --noconfirm -Syy >/dev/null 2>&1
  # Check if needed packages are installed and install them.
  for i in "${REQUIRED_PKG[@]}"; do
      sudo pacman --noconfirm -Qi "$i" >/dev/null 2>&1 || MISSING_PKG+=("$i")
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
        sudo pacman --noconfirm -S "$i" >/dev/null 2>&1 && log install_missing_package "Installed package: $i" || FAILED_PKG+=("$i") 
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

setup_debian () {
  # VARS
  REQUIRED_PKG+=("ssh" "ripgrep" "fd-find" "tree" "python3" "python3-pip" "neofetch" "gh" "btop")

  MISSING_PKG=()
  # Check Lazygit binary
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  if [[ ! -f "/usr/local/bin/lazygit" || ! "$(lazygit --version)" == *"$LAZYGIT_VERSION"* ]]; then
    log download_lazygit "Downloading lazygit"
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" >/dev/null 2>&1
    tar xf lazygit.tar.gz lazygit
    log install_lazygit "Installing lazygit"
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit
    (( UPTODATE++ ))
  fi
  NVIM_VERSION=$(curl -s "https://github.com/neovim/neovim/tags" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sed -n '1p')
  if [[ ! -f "/usr/local/bin/nvim" || ! "$(nvim --version)" == *"$NVIM_VERSION"* ]]; then
    log download_nvim "Downloading neovim"
    curl -Lo nvim "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage" >/dev/null 2>&1
    sudo chmod +x nvim
    log install_nvim "Installing neovim"
    sudo install nvim /usr/local/bin
    rm nvim
    (( UPTODATE++ ))
  fi
#  # Check for Nala repo
#  if [[ ! -f "/etc/apt/sources.list.d/volian-archive-scar-unstable.list" || ! -f "/etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg" ]]; then
#      #BUG: Scripts exits after execution of nala-sources
#      log add_nala_source "Adding nala source"
#      echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list >/dev/null 2>&1
#      if [ "$?" -ne 0 ]; then abort "$LAST_LOG_MSG"; fi
#      log add_nala_key "Adding nala key"
#      wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg >/dev/null 2>&1
#      if [ "$?" -ne 0 ]; then abort "$LAST_LOG_MSG"; fi
#      (( UPTODATE++ ))
#  fi
  # Check for NodeJS repo
  if [[ ! -f "/etc/apt/sources.list.d/nodesource.list" ]]; then
      log add_nodejs_source "Adding nodeJS source"
      #BUG: Scripts exits after node-source-scripts executes.
      sudo apt-get install -y ca-certificates curl gnupg
      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
      NODE_MAJOR=20
      echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
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
*Debian*) 
  setup_debian;;
*Arch*)
  setup_arch;;
*EndeavourOS*)
  setup_arch;;
*) 
  abort "${DISTRO} is currently not supported";;
esac

# If nothing was installed during execution exit 0
if (( $UPTODATE == 0 ));then
  success "Everything is up to date. Nothing to do." && exit 0
else
  log changes_detected "Successfully applied changes" && exit 0
fi
