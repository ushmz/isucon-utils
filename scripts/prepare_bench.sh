#!/bin/bash
set -Ce

if [[ -z "$1" ]]; then
    echo "Target host is not specified. Please setup \"~/.ssh/config\" and pass host name as 1st argument."
    exit 1
fi

# Fetch logs
# scp $1:/var/log/nginx/access.log ./access.log
# scp $1:/var/log/mysql/slow.log ./slow.log

# Restart services
ssh -t $1 "sudo rm -f /var/log/mysql/slow.log; sudo systemctl restart mysql"
ssh -t $1 "sudo rm -f /var/log/nginx/access.log; sudo systemctl restart nginx"
# Application service
# ssh $1 "sudo systemctl restart $2"
