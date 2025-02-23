setup-dockerfile:
	@./setup-dockerfile.sh
	@cd persona/dockerfiles && docker build -t colm-dev - < colm-dev-Dockerfile.dev

build: setup-dockerfile
	@cd persona && docker build -t persona -f dockerfiles/Dockerfile.dev .

run: build
	@if docker ps --format '{{.Names}}' | grep -q '^persona$$'; then \
		echo "persona is already running"; \
	else \
		echo "starting the persona container"
		docker run -d -it -v ~/.ssh:/home/vscode/.ssh:ro -v ~/persona:/workspace \
		-w /workspace -u 1000:1000 --name persona persona bash; \
		echo "persona container started"
	fi

attach: run
	@docker start -ai colm-dev-container
