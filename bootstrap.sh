#!/bin/bash
#
# Author: Luciano Antonio Borguetti Faustino
# Release Date: 29/10/2022
#
# This is a idempotent script used to provision my entire developer environment.
#
# Idempotent scripts can be called multiple times and each time it’s called, it will
# have the same effects on the system.
#
# Currently tested only in macOS Ventura 13+ (Macbook Air M2).

set -e errexit
set -u nounset

function file_changes(){

    diff "dotfiles/${*}" "${HOME}/${*}" > /dev/null 2>&1 || false

}

function file_exists(){

    stat "${HOME}/${*}" > /dev/null 2>&1 || false

}

function do_dotfile_install(){

    _dirname=""
    update_neovim=""

    if echo "${*}" | grep ".vim$" > /dev/null ; then
        update_neovim="true"
    fi

    _dirname=$(dirname "${*}") || false
    if ! file_exists "${_dirname}"; then
        mkdir -p "${HOME}/${_dirname}" > /dev/null || false
    fi
    cp -f "dotfiles/${*}" "${HOME}/${*}" > /dev/null 2>&1 || false

}

function do_dotfiles(){

    dotfile=""

    while IFS="" read -u 9 -r dotfile; do
        if ! file_exists "${dotfile}"; then
            echo -n "Ensuring the copy of the ${dotfile} dotfile: "
            if ! do_dotfile_install "${dotfile}"; then
                echo "fail"
                exit 1
            else
                echo "ok"
            fi
        else
            if ! file_changes "${dotfile}"; then
                echo -n "The file was changed, ensuring the copy of the ${dotfile} dotfile: "
                if ! do_dotfile_install "${dotfile}"; then
                    echo "fail"
                    exit 1
                else
                    echo "ok"
                fi
            fi
        fi
    done 9<<< "$(cd dotfiles && find . -type f)"

}

function package_exists(){

    brew list "${@}" > /dev/null 2>&1 || false

}

function do_package_install(){

    brew install --quiet "${@}" > /dev/null || false

}

function do_packages(){

    package=""

    while IFS="" read -u 9 -r package; do
        if ! package_exists "${package}"; then
            echo -n "Ensuring the installation of the ${package} package: "
            if ! do_package_install "${package}"; then
                echo "fail"
                exit 1
            else
                echo "ok"
            fi
        fi
    done 9< ./packages.txt

}

function do_neovim(){

    nvim +PlugUpdate  +qall > /dev/null 2>&1 || false
    nvim +PlugUpgrade +qall > /dev/null 2>&1 || false

}

do_dotfiles
do_packages
if [ "${update_neovim:-}" == "true" ]; then
    do_neovim
fi
