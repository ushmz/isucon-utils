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

.PHONY: profile
profile: access.log slow.log
	./profile_slack.sh

.PHONY: check
check:
	chmod +x spec_check.sh
	./spec_check.sh
