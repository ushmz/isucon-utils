.PHONY: deploy
deploy:
	chmod +x deploy.sh
	./deploy.sh main


.PHONY: restart_middleware
restart_middleware:
	echo "Restarting MySQL and Nginx..."
	sudo systemctl restart mysql
	sudo systemctl restart nginx

.PHONY: install_tools
install_tools:
	chmod +x install_tools.sh
	./install_tools.sh


.PHONY: startup_all
startup_all:
	install_tools
