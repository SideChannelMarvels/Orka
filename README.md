# docker
This is the Git repo of the official Docker image for SideChannelMarvels.

The Docker image aims to provide an easy way of setting up an environment where all Side-Channel Marvels are
already in the right place. Building the image with this Dockerfile will download all required libraries
and build the tools.

## Requirements
- Docker (tested on 1.10.2)

## Build instructions
~~~
docker build -t scamarvel . 
~~~
Builds the `scamarvel` image. If you want a clean rebuild without using the Docker cache, pass `--no-cache` additionally.

~~~
docker run -it scamarvel 
~~~
Starts the container. Everything should work from there except visualization. In order to view X windows it is required
to set the correct display variable, mount the X11-socket and the Xauthority file into the image:

~~~
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/root/.Xauthority -it scamarvel
~~~

To leave the container, simply type `exit`. zsh and vim are preinstalled, if you require further packages simply install them
via apt-get (you need to run apt-get update first in order to retrieve the package lists)
