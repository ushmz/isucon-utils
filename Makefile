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

.PHONY: prepare
prepare:
	chmod +x ./script/prepare_bench.darwin.sh
	./script/prepare_bench.darwin.sh

.PHONY: profile
profile:
	chmod +x ./scripts/profile.darwin.sh
	./scripts/profile.darwin.sh
