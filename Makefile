all: build

bootstrap:
	@if [ ! -d "persona" ]; then \
		echo "Cloning persona"; \
		git clone git@github.com:persona-ae/persona.git; \
	else \
		echo "The persona repo already exists"; \
	fi

	@EXCLUDE_FILE="persona/.git/info/exclude"; \
	PATTERN="^colm-dev"; \
	mkdir -p "$$(dirname "$$EXCLUDE_FILE")"; \
	touch "$$EXCLUDE_FILE"; \
	if ! grep -q "$$PATTERN" "$$EXCLUDE_FILE"; then \
		echo "Appending 'colm-dev*' to $$EXCLUDE_FILE"; \
		echo "colm-dev*" >> "$$EXCLUDE_FILE"; \
	else \
		echo "'colm-dev' already exists in $$EXCLUDE_FILE"; \
	fi

setup-dockerfile: bootstrap
	@FILE="persona/dockerfiles/Dockerfile.dev"; \
	SEARCH="FROM mcr.microsoft.com/devcontainers/python:1-3.11-bookworm"; \
	REPLACE="FROM colm-dev"; \
	if grep -q "$$SEARCH" "$$FILE"; then \
		sed -i "s|$$SEARCH|$$REPLACE|" "$$FILE"; \
		echo "Updated $$FILE"; \
	else \
		echo "No changes made. '$$SEARCH' not found in $$FILE"; \
	fi

	@cp -v ./colm-dev-Dockerfile.dev persona/dockerfiles/
	@cd persona/dockerfiles && docker build -t colm-dev - < colm-dev-Dockerfile.dev

build: setup-dockerfile
	@cd persona && docker build -t persona -f dockerfiles/Dockerfile.dev .

run:
	@if docker ps --format '{{.Names}}' | grep -q '^persona$$'; then \
		echo "persona is already running"; \
	else \
		echo "starting the persona container"; \
		docker run -d -it -v ~/.ssh:/home/vscode/.ssh:ro -v ~/persona:/workspace \
		-w /workspace -u 1000:1000 --name persona persona bash; \
		echo "persona container started"; \
	fi

attach: run
	@docker start -ai colm-dev-container

clean:
	@docker kill persona || true
	@docker rm persona || true
