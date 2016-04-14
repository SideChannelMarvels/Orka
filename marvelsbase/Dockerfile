# Use debian jessie image
FROM debian:jessie
MAINTAINER Michael Eder <michael.eder@aisec.fraunhofer.de>

# Get latest package list, upgrade packages, install required packages 
# and cleanup to keep container as small as possible
RUN dpkg --add-architecture i386
RUN apt-get update \
    && apt-get install -y \
    automake \
    build-essential \
    ca-certificates \
    clang \
    gcc-multilib \
    git \
    g++ \
    g++-multilib \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    libboost-random-dev \
    libboost-serialization-dev \
    libcapstone2 \
    libcapstone-dev \
    libntl-dev \
    libsqlite3-dev \
    libsqlite3-dev:i386 \
    libssl-dev \
    libssl-dev:i386 \
    libstdc++-4.9-dev \
    libstdc++-4.9-dev:i386 \
    qt5-qmake \ 
    qtbase5-dev-tools \
    qtbase5-dev \
    make \
    vim \
    wget \ 
    wine \
    xdotool \
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR "/root"

# get grml zshrc
RUN wget -O ~/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

# Download and build PIN
RUN wget http://software.intel.com/sites/landingpage/pintool/downloads/pin-2.14-71313-gcc.4.4.7-linux.tar.gz \
    && tar xzf pin-2.14-71313-gcc.4.4.7-linux.tar.gz \
    && mv pin-2.14-71313-gcc.4.4.7-linux /opt \
    && export PIN_ROOT=/opt/pin-2.14-71313-gcc.4.4.7-linux \
    && rm pin-2.14-71313-gcc.4.4.7-linux.tar.gz 

ENV PIN_ROOT=/opt/pin-2.14-71313-gcc.4.4.7-linux

# Download and build Valgrind
RUN wget 'http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2' \
    && tar xf valgrind-3.11.0.tar.bz2 \
    && rm -rf valgrind-3.11.0.tar.bz2 

WORKDIR "/root/valgrind-3.11.0"
RUN ./autogen.sh \
    && ./configure --prefix=/usr \
    && make -j4 \
    && make install

WORKDIR "/root"
ENTRYPOINT zsh 
