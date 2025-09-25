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
	@docker build -t colm-dev-candidate -f colm-dev-Dockerfile.dev .

run:
	@if ! docker ps --format '{{.Names}}' | grep -q '^colm-dev-candidate$$'; then \
		echo "starting the colm-dev-candidate container"; \
		docker run -d -it -v ~/.ssh:/home/vscode/.ssh:ro \
		-v ~/persona:/workspaces/persona \
		-v ~/persona:/workspace \
		-v /etc/gitconfig:/etc/gitconfig \
		-v ~/go/bin:/home/vscode/go/bin:ro \
		--network host \
		--cap-add SYS_PTRACE \
		-w /workspace -u 1000:1000 --name colm-dev-candidate colm-dev-candidate bash; \
		echo "colm-dev-candidate container started"; \
	fi
	@docker exec -it colm-dev-candidate bash; \

run-tf:
	@if ! docker ps --format '{{.Names}}' | grep -q '^colm-dev-candidate-tf$$'; then \
		echo "starting the colm-dev-candidate-tf container"; \
		docker run -d -it -v ~/.ssh:/home/vscode/.ssh:ro \
		-v ~/terraform-provider-uptrace:/workspaces/terraform-provider-uptrace \
		-v ~/terraform-provider-uptrace:/workspace \
		-v /etc/gitconfig:/etc/gitconfig \
		-v ~/go/bin:/home/vscode/go/bin:rw \
		--network host \
		-w /workspace -u 1000:1000 --name colm-dev-candidate-tf colm-dev-candidate bash; \
		echo "colm-dev-candidate-tf container started"; \
	fi
	@docker exec -it colm-dev-candidate-tf bash; \

clean:
	@docker kill colm-dev-candidate || true
	@docker rm colm-dev-candidate || true
	@docker kill colm-dev-candidate-tf || true
	@docker rm colm-dev-candidate-tf || true
