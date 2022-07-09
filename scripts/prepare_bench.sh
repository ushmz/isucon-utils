#!/bin/bash
set -Ce

# Check if an application name is set
if [[ $APP_NAME == "" ]]; then
    echo "Cannot get Application name"
    echo "Please export application name like:"
    echo "\texport APP_NAME=isuumo"
    exit 1
fi

# Check if `go` is installed
if !(type go > /dev/null 2>&1); then
    echo "go excutable file not found"
    echo "Please check your environment"
    exit 1
fi

# Clear cache
sync; sync; sync;
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"

# Load `/etc/sysctl.conf`
sudo sysctl -p
sudo systemctl daemon-reload

# Restart services
sudo rm -f /var/log/mysql/slow.log && sudo systemctl restart mysql
sudo rm -f /var/log/nginx/access.log && sudo systemctl restart nginx

# Update application code
# [TODO] : 当日のディレクトリ構成に応じて変更
cd "$HOME/$APP_NAME"
git pull origin main

# Update application binary
# [TODO] : 当日のディレクトリ構成に応じて変更
cd webapp/go
go build -o $APP_NAME ./main.go

# Restart application
# [TODO] : 当日のアプリケーション起動方法に応じて変更
sudo systemctl restart ${APP_NAME}.go
