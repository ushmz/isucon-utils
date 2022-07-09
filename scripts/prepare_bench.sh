#!/bin/bash
set -Ce

# Cleat cache
sync; sync; sync;
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"

# Load `/etc/sysctl.conf`
sudo sysctl -p
sudo systemctl daemon-reload

# Restart services
sudo rm -f /var/log/mysql/slow.log && sudo systemctl restart mysql
sudo rm -f /var/log/nginx/access.log && sudo systemctl restart nginx

# Application service
# sudo systemctl restart $1
