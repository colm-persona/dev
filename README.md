# dev

1. copy the `colm-dev-Dockerfile` into the dockerfiles dir
2. change the main devcontainer's base image to this new dockerfile (with `FROM colm-dev`)
3. build the base dockerfile on your devbox: `/persona $ docker build -t colm-dev - < dockerfiles/colm-dev-Dockerfile`
4. In VSCode: `<Cmd> + <Shift> + P` -> Rebuild Dev container
