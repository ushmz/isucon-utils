APP = isucon.sakura.q1
NGINX = isucon.sakura.q1
DB = isucon.sakura.q1

APPNAME = isucondition

.PHONY: restart_middleware
restart_middleware:
	echo "Restarting MySQL and Nginx..."
	sudo systemctl restart mysql
	sudo systemctl restart nginx

.PHONY: install_tools
install_tools:
	chmod +x ./scripts/install_tools.sh
	./scripts/install_tools.sh

.PHONY: startup_all
startup_all:
	make install_tools
.PHONY: check
check:
	chmod +x ./scripts/spec_check.sh
	./scripts/spec_check.sh

# secure copy application binary to the remote
scp-app:
	scp ./webapp/go/${APPNAME} ${APP}:~/webapp/go/${APPNAME}
	wait

restart-app:
	ssh ${APP} "sudo systemctl restart ${APPNAME}.go"
	wait

start-app:
	ssh ${APP} "sudo systemctl start ${APPNAME}.go"
	wait

stop-app:
	ssh ${APP} "sudo systemctl stop ${APPNAME}.go"
	wait

deploy-app: scp-app restart-app

scp-nginx:
	ssh ${NGINX} "sudo dd of=/etc/nginx/nginx.conf" < ./config/nginx.conf & \
	ssh ${NGINX} "sudo dd of=/etc/nginx/sites-available/${APP}.conf" < ./config/isucon.conf & \
	wait

restart-nginx:
	ssh ${DB} "sudo sysctl -p"
	ssh ${DB} "sudo systemctl daemon-reload"
	ssh ${NGINX} "sudo rm -f /var/log/nginx/access.log" & \
	ssh ${NGINX} "sudo systemctl restart nginx" & \
	wait

deploy-nginx: scp-nginx restart-nginx

deploy-db:
	ssh ${DB} "sudo dd of=/etc/mysql/my.cnf" < ./config/mysqld.conf & \
	wait

restart-db:
	ssh ${DB} "sudo sysctl -p"
	ssh ${DB} "sudo systemctl daemon-reload"
	ssh ${DB} "sudo rm -f /var/log/mysql/slow.log" & \
	ssh ${DB} "sudo systemctl restart mysql" & \
	wait

deploy-db: deploy-db restart-db

drop-cache:
	ssh ${APP} "sync;sync;sync;"
	ssh ${APP} "sudo sh -c \"echo 3 > /proc/sys/vm/drop_caches\""

.PHONY: profile
profile:
	chmod +x ./scripts/profile.darwin.sh
	sh scripts/profile.darwin.sh ${NGINX} ${DB}

.PHONY: prepare
prepare: drop-cache restart-nginx restart-db
