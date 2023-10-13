#!/bin/bash
#

apt_install(){
MISSING_PKG=()
sudo apt update -yy >/dev/null 2>&1
# Check if needed packages are installed and install them.
for i in "${REQUIRED_PKG[@]}"; do
    sudo dpkg -s "$i" >/dev/null 2>&1 || MISSING_PKG+=("$i")
done

# Skip installation of packages if already installed.
if (( ${#MISSING_PKG[@]} !=  0)); then 
  FAILED_PKG=()
  INSTALLED_PKG=()
  #printf "\n   \033[31mError: %s\033[0m\n\n" "Missing packages ${MISSING_PKG[*]}"
  info "Missing packages: ${MISSING_PKG[*]}"
  read -p "Do you want to install missing packages? [Y/n]: " choice
  choice=${choice:-Y}
  if [[ ! $choice = [Yy] ]]; then
    echo "Skipping..." && return
  fi
  info "Installing the missing packages now"
  for i in "${MISSING_PKG[@]}"; do
    sudo apt install -y "$i" >/dev/null 2>&1 && log "Installed package: $i" || FAILED_PKG+=("$i") 
  done
  if (( ${#FAILED_PKG[@]} != 0 )); then
    error "Failed to install the following packages: ${FAILED_PKG[*]}" 1
  fi
(( UPTODATE++ ))
fi
}
