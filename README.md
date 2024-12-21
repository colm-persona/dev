# dev

Building:
1. copy the `colm-dev-Dockerfile.dev` into the dockerfiles dir
1. change the main devcontainer's base image to this new dockerfile (with `FROM colm-dev`)
1. build the base dockerfile on your devbox: `/persona $ docker build -t colm-dev - < dockerfiles/colm-dev-Dockerfile.dev`
1. run the dockerfile with: `$ docker run -it -v ~/.ssh:/root/.ssh:ro -v ~/persona:/workspace -w /workspace -u 1000:1000 --name colm-dev-container colm-dev bash`

Attaching:
1. `docker start -ai colm-dev-container`

---
### Todo:
- [ ] update dotfiles so that the lua config has the right python deps
- [x] install npm for stupid packages that need it
- [x] get git setup
	- [x] allow commits / fetch / merge / etc.
	- [x] correct ownership
	- [ ] shortcuts
