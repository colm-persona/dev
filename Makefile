all: build

bootstrap:
	@if [ ! -d "dotfiles" ]; then \
		echo "Cloning dotfiles"; \
		git clone git@github.com:colm-persona/dotfiles.git; \
	else \
		echo "The dotfiles repo already exists"; \
		cd dotfiles && git pull; \
	fi

build-base:
	@cd ~/persona && docker build -t persona -f dockerfiles/Dockerfile.dev .

build: bootstrap build-base
	@docker build -t colm-dev -f colm-dev-Dockerfile.dev .

run:
	@if ! docker ps --format '{{.Names}}' | grep -q '^colm-dev$$'; then \
		echo "starting the colm-dev container"; \
		docker run -d -it -v ~/.ssh:/home/vscode/.ssh:ro \
		-v ~/persona:/workspaces/persona -v ~/persona:/workspace \
		-w /workspace -u 1000:1000 --name colm-dev colm-dev bash; \
		echo "colm-dev container started"; \
		docker exec -d colm-dev dmypy run .; \
	fi
	@docker exec -it colm-dev bash; \

clean:
	@docker kill colm-dev || true
	@docker rm colm-dev || true
