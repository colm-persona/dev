# dev

Building:
1. copy the `colm-dev-Dockerfile` into the dockerfiles dir
2. change the main devcontainer's base image to this new dockerfile (with `FROM colm-dev`)
3. build the base dockerfile on your devbox: `/persona $ docker build -t colm-dev - < dockerfiles/colm-dev-Dockerfile`
4. In VSCode: `<Cmd> + <Shift> + P` -> Rebuild Dev container

Attaching:
1. run `docker ps` to find the vscode devcontainer
2. run `docker exec -it <container_name> /bin/bash`
3. or as a one-liner: `$ name=$(docker ps | grep vsc-persona | head -1 | rev | awk '{print $1}' | rev); docker exec -it $name /bin/bash`
