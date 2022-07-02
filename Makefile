.PHONY: deploy
deploy:
	chmod +x deploy.sh
	./deploy.sh main


.PHONY: restart_middleware
restart_middleware:
	echo "Restarting MySQL and Nginx..."
	sudo systemctl restart mysql
	sudo systemctl restart nginx