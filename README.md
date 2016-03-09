# Orka
*Orka can communicate with and command killer whales using his tonally unique and compelling sounds, directing up to hundreds of whales at once. He can augment his physical might by drawing strength from killer
whales in his immediate vicinity.*

Orka is the Git repo of the official Docker image for SideChannelMarvels.

The Docker images aim to provide an easy way of setting up an environment where all Side-Channel Marvels are
already in the right place. Building the images with this Dockerfiles will download all required libraries
and build the tools.

## Requirements
- Docker (tested on 1.10.2)

## Build instructions
First, build the scamarvel base image. It contains all required packages from the Debian repositories
and downloads and builds vanilla PIN and Valgrind distributions without the SCA marvels.

~~~
docker build -t marvelsbase ./marvelsbase/
~~~
Builds the `marvelsbase` image. If you want a clean rebuild without using the Docker cache, 
pass `--no-cache` additionally.

The build of the `scamarvels` image fetches latest git and rebuilds the tools:
~~~
docker build --no-cache -t scamarvels ./marvelslatest
~~~
The `--no-cache` option here is required to force a rebuild because Docker's cache is not aware of git changes in the
repositories.

~~~
docker run -it scamarvels 
~~~
Starts the container. Everything should work from there except visualization. 
In order to view X windows it is required to set the correct display variable, 
mount the X11-socket and the Xauthority file into the image:

~~~
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/root/.Xauthority -it scamarvels
~~~

To leave the container, simply type `exit`. zsh and vim are preinstalled, 
if you require further packages simply install them via apt-get 
(you need to run apt-get update first in order to retrieve the package lists)
