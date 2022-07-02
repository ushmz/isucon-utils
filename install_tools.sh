#!/bin/bash

info() {
    printf "[\033[00;34mINFO\033[0m] $1\n"
}

success() {
    printf "[\033[00;32mOK\033[0m] $1\n"
}

error() {
    printf "[\033[00;31mERROR\033[0m] $1\n"
}

install_all_tools() {
    info "-------------------------------------"
    info "Installing pt-query-digest..."
    info "-------------------------------------"
    
    install_pt_query_digest
    install_alp
    
    success "-------------------------------------"
    success "Successfully installed all_tools!"
    success "-------------------------------------"
}

install_pt_query_digest() {
    info "Installing pt-query-digest..."

    wget https://github.com/percona/percona-toolkit/archive/3.3.1.tar.gz
    tar zxvf 3.3.1.tar.gz
    sudo mv ./percona-toolkit-3.3.1/bin/pt-query-digest /usr/bin/
    rm 3.3.1.tar.gz
    rm -rf percona-toolkit-3.3.1

    success "Successfully installed pt-query-digest!"
}

install_alp() {
    info "Installing alp..."

    wget https://github.com/tkuchiki/alp/releases/download/v1.0.9/alp_linux_amd64.zip
    unzip alp_linux_amd64.zip
    sudo install ./alp /usr/local/bin
    rm alp_linux_amd64.zip

    success "Successfully installed alp!"
}
