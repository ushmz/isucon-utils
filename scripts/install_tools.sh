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
    install_netdata
    
    # newrelicは鍵が必要なので，サーバー内でコマンド打つのが早い
    info "If you want to install newrelic, check below"
    echo "https://one.newrelic.com/marketplace?account=2818904&duration=1800000&state=8b55894e-b91c-dc0e-34f1-ca0c4b96d910"
    
    success "-------------------------------------"
    success "Successfully installed all_tools!"
    success "-------------------------------------"
}

install_pt_query_digest() {
    info "Installing pt-query-digest..."
    sudo apt-get install percona-toolkit
    success "Successfully installed pt-query-digest!"
}

install_netdata() {
    info "Installing netdata..."
    wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh
    sh /tmp/netdata-kickstart.sh
    success "Successfully installed netdata!"
}

install_alp() {
    info "Installing alp..."

    wget https://github.com/tkuchiki/alp/releases/download/v1.0.9/alp_linux_amd64.zip
    unzip alp_linux_amd64.zip
    sudo install ./alp /usr/local/bin
    rm alp_linux_amd64.zip

    success "Successfully installed alp!"
}

# --execute---------------------
install_all_tools
