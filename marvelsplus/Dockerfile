# This image adds 2 things on top of the vanilla Orka scamarvels image:
#  * Jlsca toolbox, with tutorials
#  * data and scripts for reproducing experiments with dimensionality reduction techniques
#
# 1. To build this image, you need first to get and build images marvelsbase
# and scamarvels from ScaMarvels Orka images. See the instructions in Orka's README.md.
# Once you have built them, build this image:
# docker build --no-cache -t scamarvelsplus ./marvelsplus
#
# 2. This is how to start this container:
# docker run --privileged -it -p 8888:8888 scamarvelsplus
# 
# 3. To have a shared folder (e.g. for persistent storage or to copy files from the host),
# add the option
# -v ~/dockershare:/mnt
# to the above command, where ~/dockershare is an existing host file system folder
#
# 4. Two ways to start the notebook server in the container:
# julia -e 'using IJulia; notebook()'
# or  
# ~/.julia/v0.6/Conda/deps/usr/bin/jupyter notebook
# The first one is preferential beacuse it can be preceded by JULIA_NUM_THREADS=2
# setting that will make the server start with 2 threads (or whatever nubmer you choose).
#
# Once the notebook server is started, go to localhost:8888 in your browser on the host

# Use ScaMarvels image as base
FROM scamarvels
MAINTAINER Ilya Kizhvatov <ilya.kizhvatov@gmail.com>

# Install Git Large File Storage extension (experimental repo stores tracesets using LFS)
RUN apt-get update \
    && apt-get install -y curl \
    && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get install -y git-lfs \
    && git lfs install

# Install time
RUN apt-get install -y time

# Install matplotlib in python3 (installs numpy as a dependency)
RUN apt-get install -y python3-matplotlib

# Install Julia (we stick to the 0.6.2 for now to avoid incompatibilites)
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.2-linux-x86_64.tar.gz \
    && tar xf julia-0.6.2-linux-x86_64.tar.gz \
    && rm julia-0.6.2-linux-x86_64.tar.gz \
    && ls -d julia-* | xargs -t -I foo ln -s ~/foo/bin/julia /usr/local/bin/julia

# Install IJulia and other packages, letting Julia do an internal miniconda install,
# then adjust jupyter config to make notebook server launchable
# TODO: switch to the system-wide miniconda
RUN julia -e 'Pkg.init(); ENV["PYTHON"]=""; Pkg.add("PyPlot"); Pkg.add("IJulia")' \
    && mkdir .jupyter \
    && echo "c.NotebookApp.allow_root = True\nc.NotebookApp.ip = '*'\nc.NotebookApp.open_browser = False\nc.NotebookApp.token = ''" > .jupyter/jupyter_notebook_config.py

# Install Jlsca as Julia package
# TODO: install a particular release
RUN julia -e 'Pkg.clone("https://github.com/Riscure/Jlsca")'

# Get Jlsca tutorials
RUN git clone https://github.com/ikizhvatov/jlsca-tutorials

# Get the experimental package for the conditional reduction paper
RUN git clone https://gitlab.science.ru.nl/wbsca/experiments

# Keep zsh as entrypoint as scamarvels stuff is made for it
# For running jlsca stuff go into bash manually
ENTRYPOINT zsh
