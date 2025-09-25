all: run

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
		-v ~/persona:/workspaces/persona \
		-v ~/persona:/workspace \
		-v /etc/gitconfig:/etc/gitconfig \
		-v ~/go/bin:/home/vscode/go/bin:ro \
		--network host \
		--cap-add SYS_PTRACE \
		-w /workspace -u 1000:1000 --name colm-dev colm-dev bash; \
		echo "colm-dev container started"; \
	fi
	@docker exec -it colm-dev bash; \

run-tf:
	@if ! docker ps --format '{{.Names}}' | grep -q '^colm-dev-tf$$'; then \
		echo "starting the colm-dev-tf container"; \
		docker run -d -it -v ~/.ssh:/home/vscode/.ssh:ro \
		-v ~/terraform-provider-uptrace:/workspaces/terraform-provider-uptrace \
		-v ~/terraform-provider-uptrace:/workspace \
		-v /etc/gitconfig:/etc/gitconfig \
		-v ~/go/bin:/home/vscode/go/bin:rw \
		--network host \
		-w /workspace -u 1000:1000 --name colm-dev-tf colm-dev bash; \
		echo "colm-dev-tf container started"; \
	fi
	@docker exec -it colm-dev-tf bash; \

clean:
	@docker kill colm-dev || true
	@docker rm colm-dev || true
	@docker kill colm-dev-tf || true
	@docker rm colm-dev-tf || true
