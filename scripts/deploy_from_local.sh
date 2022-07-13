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

# SERVICE_NAMEの調べ方: sudo systemctl list-unit-files --type=service | grep isu
SERVICE_NAME=$1
DEPLOY_APP_TARGET_DIR=$2 # e.g. /home/isucon/isucari/webapp/go/isucari
# dir末尾の/を必ずつける
DEPLOY_SQL_TARGET_DIR=$3 # e.g. /home/isucon/isucari/webapp/sql/

GOOS=linux GOARCH=amd64 go build -o main_linux
for server in isu01 isu02; do
    info "Start deploy to ${server}..."

    ssh -t $server "sudo systemctl stop $SERVICE_NAME"
    scp "./webapp/go/$APP_NAME" $server:"$DEPLOY_APP_TARGET_DIR"
    # https://qiita.com/catatsuy/items/66aa402cbb4c9cffe66b
    # rsync -vau ../sql/ $server:"$DEPLOY_SQL_TARGET_DIR"
    # TODO: 必要であれば他middlewareの設定も同期させる
    ssh -t $server "sudo systemctl start $SERVICE_NAME"

    success "Successfully deployed to ${server}!"
done
