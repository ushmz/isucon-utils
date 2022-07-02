.PHONY: restart_middleware
restart_middleware:
	echo "Restarting MySQL and Nginx..."
	sudo systemctl restart mysql
	sudo systemctl restart nginx

.PHONY: fetch_scripts
fetch_scripts:
	curl -O https://raw.githubusercontent.com/ushmz/isucon-utils/main/Makefile
	curl -O https://raw.githubusercontent.com/ushmz/isucon-utils/main/scripts

.PHONY: install_tools
install_tools:
	chmod +x ./scripts/install_tools.sh
	./scripts/install_tools.sh

.PHONY: startup_all
startup_all:
	make fetch_scripts
	make install_tools

.PHONY: profile
profile: access.log slow.log
	./profile_slack.sh
