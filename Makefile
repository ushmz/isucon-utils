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
	chmod +x spec_check.sh
	./spec_check.sh

.PHONY: prepare
prepare:
	./prepare_bench.sh

.PHONY: profile
profile:
	./profile.sh
