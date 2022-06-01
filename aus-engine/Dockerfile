FROM python:3.7.9-slim-buster

LABEL Description="Ausschalten - DDOS collection"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV HOME /root/ausschalten

# ENV http_proxy http://172.17.0.1:8080
# ENV https_proxy http://172.17.0.1:8080

RUN apt-get update && apt-get -y install gcc git python3-pip tcl-dev libpcap-dev 
WORKDIR $HOME

# [Pre-instalation]
RUN ln -s /usr/include/pcap/bpf.h /usr/include/net/bpf.h
RUN mkdir -p /usr/local/man/man8

# [Instalation]
# > hping
RUN git clone https://github.com/antirez/hping.git ; cd hping ; ./configure && make && make install 
# > dns-flood
RUN git clone https://github.com/cmosek/dns-flood-ng ; cd dns-flood-ng ; make && cp dnsflood /usr/bin/
# > copy runner
COPY . .
RUN pip install -r requirements.txt

# [Post-instalation]
# > copy hping stdlib
RUN cp $HOME/hping/lib/hpingstdlib.htcl $HOME/dist/tcl/
# > clen-up 
RUN rm -rf hping dns-flood-ng ; apt-get clean
# RUN unset http_proxy https_proxy

ENTRYPOINT ["/usr/bin/env", "python3","./runner.py"]