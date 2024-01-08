FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y vim tmux htop curl zip \
    && curl -fsSL https://bun.sh/install | bash

ADD vimrc /root/.vimrc

# Common in 'contain' utility
WORKDIR /hostdata

