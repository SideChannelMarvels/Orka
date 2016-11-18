#!/bin/bash

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
[ -e /tmp/.docker.xauth ] || \
    xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
if ! docker ps -a -f name=sca --format="{{.Names}}"|grep -q sca; then
    docker run -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH -e DISPLAY=$DISPLAY -e PIN_ROOT=/opt/pin-2.14-71313-gcc.4.4.7-linux --privileged -it --name sca scamarvels zsh
else
    if ! docker ps -f name=sca --format="{{.Names}}"|grep -q sca; then
        docker start sca
    fi
    docker exec --privileged -it sca zsh
fi
