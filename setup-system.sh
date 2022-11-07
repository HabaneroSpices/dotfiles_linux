#!/bin/bash
#

set -e
# Color StdErr
#exec 2> >(while read line; do echo -e "\e[01;31m$line\e[0m"; done)

# Make sure we're in the correct directory
dotfiles_dir="$(
    cd "$(dirname "$0")"
    pwd
)"
cd "$dotfiles_dir"

OS=$(uname)
DISTRO=$(lsb_release -i | cut -f 2-)
UPTODATE=0

REQUIRED_PKG=("ripgrep" "fd-find" "git" "curl" "neovim" "wget" "zip" "unzip" "tar" "htop" "sshpass" "python3" "python3-pip" "neofetch" "ssh")
MISSING_PKG=()

color () {
  RED="\e[31m"
  GREEN="\e[32m"
  YELLOW="\e[33m"
  ENDCOLOR="\e[0m"

  case $1 in
    G)
      OUT="${GREEN}${2}${ENDCOLOR}";;
    R)
      OUT="${RED}${2}${ENDCOLOR}";;
    Y)
      OUT="${YELLOW}${2}${ENDCOLOR}";;
    *)
      OUT="${2}";;
  esac
  echo -e "${OUT}"
}
configure_debian_repos () {
    color "." "\n### configure_debian_repos"
    if ! grep -q testing "/etc/apt/sources.list"; then
        color "G" "[+] ADDING Testing + Testing/updates repos"

cat <<EOF >> /etc/apt/sources.list
# Testing repository - main, contrib and non-free branches
deb http://deb.debian.org/debian testing main non-free contrib
deb-src http://deb.debian.org/debian testing main non-free contrib

# Testing security updates repository
deb http://security.debian.org/ testing/updates main contrib non-free
deb-src http://security.debian.org/ testing/updates main contrib non-free
EOF

cat <<EOF >> /etc/apt/preferences.d/pinning
Package: *
Pin: release a=stable
Pin-Priority: 700

Package: *
Pin: release a=testing
Pin-Priority: 650
EOF

        apt update -yy
    else
        color "." "[*] Testing repos already present in /etc/apt/sources.list"
    fi
}
install_debian_packages () {
    color "." "\n### install_debian_packages"
  # Check if needed packages are installed and install them.
  for i in "${REQUIRED_PKG[@]}"; do
      sudo dpkg -s "$i" >/dev/null 2>&1 || MISSING_PKG+=("$i")
  done

  # Skip installation of packages if already installed.
  if (( ${#MISSING_PKG[@]} !=  0)); then 
    FAILED_PKG=()
    INSTALLED_PKG=()
    color "Y" "[i] Missing packages ${MISSING_PKG[*]}"
    read -p "Do you want to install missing packages? [Y/n]: " choice
    choice=${choice:-Y}
    if [[ $choice = [Yy] ]]; then
      color "." "[*] Installing: ${MISSING_PKG[*]}"
      for i in "${MISSING_PKG[@]}"; do
        sudo apt -t testing install -y "$i" >/dev/null 2>&1 && color "G" "[+] Installed package: $i" || FAILED_PKG+=("$i") 
      done
    else
      echo -e "\nUser answered no - exiting" && exit 0
    fi
    if (( ${#FAILED_PKG[@]} != 0 )); then
      color "R" "[!] Failed to install the following packages: ${FAILED_PKG[*]}" && exit 1
    fi
    (( UPTODATE++ ))
  else
      color "." "[*] Packages already installed"
  fi
}

color "." "-------- Host Information --------"
if [ $OS = "Linux" ];
then
    color "G" "OS:\t${OS}"
    case $DISTRO in
    Debian)
        color "G" "DISTRO:\t${DISTRO}"
        if [[ ! "$EUID" = 0 ]]; then 
            color "R" "Not running as root or with sudo privledges. Please rerun as root OR sudo like this:\n\tsudo bash -c ./setup-system.sh" && exit 1; fi
        configure_debian_repos
        install_debian_packages;;
    *)
        color "R" "DISTRO:\t${DISTRO} is currently not supported" && exit 1;;
    esac
else
    color "R" "OS:\t${OS} is not currently supported" && exit 1
fi

# If nothing was installed during execution exit 0
if (( $UPTODATE == 0 ));then
  color "G" "Everything is up to date. Nothing to do."
  exit 2
fi
