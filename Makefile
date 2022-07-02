.PHONY: deploy
deploy:
	chmod +x deploy.sh
	./scripts/deploy.sh main


.PHONY: restart_middleware
restart_middleware:
	echo "Restarting MySQL and Nginx..."
	sudo systemctl restart mysql
	sudo systemctl restart nginx

.PHONY: install_tools
install_tools:
	chmod +x install_tools.sh
	./scripts/install_tools.sh

.PHONY: startup_all
startup_all:
	make install_tools

.PHONY: profile
profile: access.log slow.log
	./profile_slack.sh
