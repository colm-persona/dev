setup-dockerfile:
	@./setup-dockerfile.sh
	@cd persona/dockerfiles && docker build -t colm-dev - < colm-dev-Dockerfile.dev

build: setup-dockerfile
	@cd persona && docker build -t persona -f dockerfiles/Dockerfile.dev .
