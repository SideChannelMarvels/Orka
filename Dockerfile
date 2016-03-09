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
    libcapstone2 \
    libcapstone-dev \
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
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR "/root"

# get grml zshrc
RUN wget -O ~/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

# get SCAMarvels
RUN git clone https://github.com/SideChannelMarvels/Daredevil
RUN git clone https://github.com/SideChannelMarvels/Deadpool
RUN git clone https://github.com/SideChannelMarvels/Tracer

# Download and build PIN
RUN wget http://software.intel.com/sites/landingpage/pintool/downloads/pin-2.13-65163-gcc.4.4.7-linux.tar.gz \
    && tar xzf pin-2.13-65163-gcc.4.4.7-linux.tar.gz \
    && mv pin-2.13-65163-gcc.4.4.7-linux /opt \
    && export PIN_ROOT=/opt/pin-2.13-65163-gcc.4.4.7-linux \
    && rm pin-2.13-65163-gcc.4.4.7-linux.tar.gz 

ENV PIN_ROOT=/opt/pin-2.13-65163-gcc.4.4.7-linux

WORKDIR "/root/Tracer/TracerPIN"
RUN make \
    && cp -a Tracer /usr/local/bin \
    && cp -a obj-* /usr/local/bin

WORKDIR "/root/Tracer/TraceGraph"
RUN qmake -qt=5 \
    && make \
    && make install

WORKDIR "/root"

# Download and build Valgrind
RUN wget 'http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2' \
    && tar xf valgrind-3.11.0.tar.bz2 \
    && rm -rf valgrind-3.11.0.tar.bz2 \
    && cp -r Tracer/TracerGrind/tracergrind valgrind-3.11.0 \
    && patch -p0 < Tracer/TracerGrind/valgrind-3.11.0.diff

WORKDIR "/root/valgrind-3.11.0"
RUN ./autogen.sh \
    && ./configure --prefix=/usr \
    && make -j4 \
    && make install

WORKDIR "/root/Tracer/TracerGrind/texttrace"
RUN make \
    && make install PREFIX=/usr

WORKDIR "/root/Tracer/TracerGrind/sqlitetrace"
RUN make \
    && make install PREFIX=/usr

WORKDIR "/root"
ENTRYPOINT zsh 
