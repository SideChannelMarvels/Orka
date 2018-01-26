# Orka
*Orka can communicate with and command killer whales using his tonally unique and compelling sounds, directing up to hundreds of whales at once. He can augment his physical might by drawing strength from killer
whales in his immediate vicinity.*

Orka is the Git repo of the official Docker image for SideChannelMarvels.

The Docker images aim to provide an easy way of setting up an environment where all Side-Channel Marvels are
already in the right place. Building the images with this Dockerfiles will download all required libraries
and build the tools.

## Requirements
- Docker (tested on 17.12.0-ce, build c97c6d6)

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
docker run --privileged -it scamarvels 
~~~
Starts the container. Everything should work from there except visualization. 
In order to view X windows it is required to set the correct display variable, 
mount the X11-socket and the Xauthority file into the image:

~~~
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/root/.Xauthority --privileged -it scamarvels
~~~

To leave the container, simply type `exit`. zsh and vim are preinstalled, 
if you require further packages simply install them via apt-get 
(you need to run apt-get update first in order to retrieve the package lists)

## ScaMarvelsPlus image

The `scamarvelsplus` image adds the following things on top of `scamarvels`:
* [Jlsca toolbox](https://github.com/Riscure/Jlsca) with [tutorials](https://github.com/ikizhvatov/jlsca-tutorials), and the environment to run it
* [trasets and and scripts](https://github.com/ikizhvatov/conditional-reduction) to reproduce experiments with sample reduction in software execution traces

Build this image:
~~~
docker build --no-cache -t scamarvelsplus ./marvelsplus
~~~

Start this image with the port forwarded for Jupyter notebook:
~~~
# docker run --privileged -it -p 8888:8888 scamarvelsplus
~~~

To have a shared folder for persistent storage or to access files on the host, add `-v ~/dockershare:/mnt` to the above command, where `~/dockershare` is an existing host file system folder.

To play with the tutorials, start Jupyter notebook server in the container:
~~~
julia -e 'using IJulia; notebook()'
~~~
Prepend this command with `JULIA_NUM_THREADS=2` to give Julia interpreter 2 threads (or whatever number you choose).
Once the notebook server is started, go to _localhost:8888_ in your browser on the host

## Troubleshooting
#### TracerPIN
See the [TracerPIN troubleshooting section](https://github.com/SideChannelMarvels/Tracer/tree/master/TracerPIN#troubleshooting)

#### Hack.lu 2009
When running `wine notepad.exe` the first time for Hack.lu 2009, it offers you to install mono. Simply decline. After that, notepad is killed. Now running `wine notepad.exe &` will start a new notepad which does not get killed and it's not required
to attach a second terminal to the container. Running the DCA [as described](https://github.com/SideChannelMarvels/Deadpool/tree/master/wbs_aes_hacklu2009/DCA) should work without problems on the container connected to your X server.


