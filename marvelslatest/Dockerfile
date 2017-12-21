# Use debian stretch image
FROM marvelsbase 
MAINTAINER Michael Eder <michael.eder@aisec.fraunhofer.de>

# get SCAMarvels
RUN git clone https://github.com/SideChannelMarvels/Daredevil
RUN git clone https://github.com/SideChannelMarvels/Deadpool
RUN git clone https://github.com/SideChannelMarvels/Tracer
RUN git clone https://github.com/SideChannelMarvels/JeanGrey
RUN git clone https://github.com/SideChannelMarvels/Stark
RUN git clone https://github.com/ph4r05/Whitebox-crypto-AES

WORKDIR "/root/Tracer/TraceGraph"
RUN qmake -qt=5 \
    && make \
    && make install

WORKDIR "/root"

RUN cp -r Tracer/TracerGrind/tracergrind valgrind-3.13.0 \
    && patch -p0 < Tracer/TracerGrind/valgrind-3.13.0.diff

WORKDIR "/root/valgrind-3.13.0"
RUN ./autogen.sh \
    && ./configure \
    && make -j4 \
    && make install

WORKDIR "/root/Tracer/TracerGrind/texttrace"
RUN make \
    && make install

WORKDIR "/root/Tracer/TracerGrind/sqlitetrace"
RUN make \
    && make install

WORKDIR "/root/Daredevil"
RUN make \
    && make install

WORKDIR "/root/Stark"
RUN make \
    && make install

WORKDIR "/root/Whitebox-crypto-AES"
RUN ./build-release.sh \
    && cp build-release/main ../Deadpool/wbs_aes_karroumi2010/target/

#WORKDIR "/root/Tracer/TracerPIN"
# This requires GCC 4.4.7...
#RUN make \
#    && cp -a Tracer /usr/local/bin \
#    && cp -a obj-* /usr/local/bin

WORKDIR "/root"
RUN echo "export PATH=\$PATH:/usr/local/bin" >> .bash_profile
ENTRYPOINT zsh 
