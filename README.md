# dev

Building:
1. copy the `colm-dev-Dockerfile.dev` into the dockerfiles dir
1. change the main devcontainer's base image to this new dockerfile (with `FROM colm-dev`)
1. build the base dockerfile on your devbox: `/persona $ docker build -t colm-dev - < dockerfiles/colm-dev-Dockerfile.dev`
1. then build the main dockerfile on your devbox: `~/persona$ docker build -t persona -f dockerfiles/Dockerfile.dev .`
1. run the dockerfile with: 
```bash
$ docker run -it -v ~/.ssh:/home/vscode/.ssh:ro -v ~/persona:/workspace -w /workspace -u 1000:1000 --name colm-dev-container persona bash
```

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

fix ownership again..

docker buildx build --load \
    --build-arg BUILDKIT_INLINE_CACHE=1 
    -f /tmp/devcontainercli-ubuntu/container-features/0.73.0-1740758420327/Dockerfile-with-features 
    -t vsc-persona-94f734311748cdcf954d86e622f4b200653198ed74952e91c3ec3e1c671120af 
    --target dev_containers_target_stage 
    --build-context dev_containers_feature_content_source=/tmp/devcontainercli-ubuntu/container-features/0.73.0-1740758420327 
    --build-arg _DEV_CONTAINERS_BASE_IMAGE=dev_container_auto_added_stage_label 
    --build-arg _DEV_CONTAINERS_IMAGE_USER=root 
    --build-arg _DEV_CONTAINERS_FEATURE_CONTENT_SOURCE=dev_container_feature_content_temp 
    /mnt/persona-disk/home/ubuntu/persona
