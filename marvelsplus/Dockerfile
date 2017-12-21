# This image adds 2 things on top of the vanilla Orka scamarvels image:
#  * Jlsca toolbox, with tutorials
#  * experimental data and scripts for paper on conditional reduction
#
# 1. To build this image, you need first to get and build images marvelsbase
# and scamarvels from ScaMarvels Orka images. Once you have built them,
# build this image
# docker build --no-cache -t scamarvelsplus ./marvelsplus
#
# 2. This is how to start this container
# docker run --privileged -it -p 8888:8888 scamarvelsplus
# 
# 3. To have a shared folder, add option -v ~/dockershare:/mnt to the above
# line, where ~/dockershare is an existing host file system folder
#
# 4. Two ways to start the notebook server in the container:
# julia -e 'using IJulia; notebook()'
# or  
# ~/.julia/v0.6/Conda/deps/usr/bin/jupyter notebook
# The first one is preferential beacuse it can be preceded by JULIA_NUM_THREADS=2
# setting that will make the server start with 2 threads (or whatever nubmer you type).
# Then you can go to localhost:8888 in your browser

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

# Install Julia
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.2-linux-x86_64.tar.gz \
    && tar xf julia-0.6.2-linux-x86_64.tar.gz \
    && rm julia-0.6.2-linux-x86_64.tar.gz \
    && ls -d julia-* | xargs -t -I foo ln -s ~/foo/bin/julia /usr/local/bin/julia

# Install IJulia and other packages, letting Julia do an internal miniconda install,
# then adjust jupyter config to make notebook server launchable
RUN julia -e 'Pkg.init(); ENV["PYTHON"]=""; Pkg.add("PyPlot"); Pkg.add("IJulia")' \
    && mkdir .jupyter \
    && echo "c.NotebookApp.allow_root = True\nc.NotebookApp.ip = '*'\nc.NotebookApp.open_browser = False\nc.NotebookApp.token = ''" > .jupyter/jupyter_notebook_config.py

# Install Jlsca as Julia package. TODO: install a particular release
RUN julia -e 'Pkg.clone("https://github.com/Riscure/Jlsca")'

# Get Jlsca tutorials
RUN git clone https://github.com/ikizhvatov/jlsca-tutorials

# Get the experimental package for the conditional reduction paper
RUN git clone https://gitlab.science.ru.nl/wbsca/experiments

# Keep zsh as entrypoint as scamarvels stuff is made for it
# For running jlsca stuff go into bash manually
ENTRYPOINT zsh
