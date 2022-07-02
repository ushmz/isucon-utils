#!/bin/bash

set -x

info() {
    printf "[\033[00;34mINFO\033[0m] $1\n"
}

success() {
    printf "[\033[00;32mOK\033[0m] $1\n"
}

error() {
    printf "[\033[00;31mERROR\033[0m] $1\n"
}

SERVICE_NAME=$1
DEPLOY_APP_TARGET_DIR=$2 # e.g. /home/isucon/isucari/webapp/go/isucari
DEPLOY_SQL_TARGET_DIR=$3 # e.g. /home/isucon/isucari/webapp/sql/

# scriptsやMakefileなどはgit pullではなくてcurlで置く想定

GOOS=linux GOARCH=amd64 go build -o main_linux
for server in isu01 isu02; do
    info "Start deploy to ${server}..."

    # -------------------------
    # sync files
    # -------------------------
    ssh -t $server "sudo systemctl stop $SERVICE_NAME"
    scp ./main_linux $server:"$DEPLOY_APP_TARGET_DIR"
    # TODO: sql配下を書き換え
    # rsync -vau ../sql/ $server:"$DEPLOY_SQL_TARGET_DIR"
    # TODO: 必要であれば他middlewareの設定も同期させる
    # --
    ssh -t $server "sudo systemctl start $SERVICE_NAME"
    success "Successfully deployed to ${server}!"
done
