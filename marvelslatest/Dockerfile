# Use debian jessie image
FROM marvelsbase 
MAINTAINER Michael Eder <michael.eder@aisec.fraunhofer.de>

# get SCAMarvels
RUN git clone https://github.com/SideChannelMarvels/Daredevil
RUN git clone https://github.com/SideChannelMarvels/Deadpool
RUN git clone https://github.com/SideChannelMarvels/Tracer

WORKDIR "/root/Tracer/TracerPIN"
RUN make \
    && cp -a Tracer /usr/local/bin \
    && cp -a obj-* /usr/local/bin

WORKDIR "/root/Tracer/TraceGraph"
RUN qmake -qt=5 \
    && make \
    && make install

WORKDIR "/root"

RUN cp -r Tracer/TracerGrind/tracergrind valgrind-3.11.0 \
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
