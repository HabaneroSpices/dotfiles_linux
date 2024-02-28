#!/bin/bash
#
# Functions for the shell :)
#

# 1: command name, 2: alias
function ifCmdExist() {
	command -v $1 &>/dev/null && true || false
}

#start () { nohup "$@" > /dev/null 2>&1 & disown }
function ping() { command ping "${1:-1.1.1.1}"; }

# Password generator
function genpass() {
	local l=$1
	[[ "$1" == "" ]] && l=16
	tr -dc A-Za-z0-9_ </dev/urandom | head -c ${l} | xargs
}

# If file is owned by root, try using sudo.
function e(){
    OWNER=$(stat -c '%U' $1) > /dev/null 2>&1
    if [[ "$OWNER" == "root" ]]; then
        if confirm=$(bash -c '
        read -p "The file youre trying to write is owned by root. Do you want to open the file with sudo?" -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then exit 0; else exit 1; fi
        ')
        then
            sudo $EDITOR $*;
        fi
        return
    else
        $EDITOR $*;
        return
    fi
}
