FROM ubuntu:18.04


RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial-security main" | tee -a /etc/apt/sources.list
RUN apt-get update && \
  apt-get install -y curl build-essential gcc make cmake libtool zlib1g-dev libpng-dev libaec-dev libjpeg-dev curl git libopenjp2-7-dev libjasper-dev python

ENV GOLANG_VERSION 1.11.4
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz
ENV PATH /root/go/bin:/usr/local/go/bin:$PATH
#COPY . /root/go-eccodes

WORKDIR /root
RUN curl -L "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.10.0-Source.tar.gz?api=v2" --output 2.10.tar.gz
RUN tar -xzvf 2.10.tar.gz
RUN mkdir /root/build
WORKDIR /root/build
RUN cmake -DENABLE_PNG=on -DENABLE_JPG=on -DENABLE_AEC=on  -DENABLE_ECCODES_THREADS=on -DENABLE_MEMFS=on -DBUILD_SHARED_LIBS=both -DENABLE_FORTRAN=off -DCMAKE_INSTALL_PREFIX=/usr/local ../eccodes-2.10.0-Source/
RUN make install
RUN ln -s /usr/local/lib/libeccodes.so /usr/lib/libeccodes.so
RUN ln -s /usr/local/lib/libeccodes_memfs.so /usr/lib/libeccodes_memfs.so
RUN rm -rf /var/lib/apt/lists/* /root/2.10.tar.gz
WORKDIR /home/dusr/code


