# syntax=docker/dockerfile:1
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN useradd -m docker

RUN apt update -y && apt upgrade -y && apt install -y \
        sudo \
        curl\
        wget\
        lsb-release\
        software-properties-common\
        gnupg\
        build-essential \
        git \
        python3 \
        python3-venv \
        python3-dev \
        python3-pip \
        cmake \
        ninja-build \
        libboost-all-dev \
        doxygen \
        graphviz \
        texlive \
        latexmk

RUN echo 'docker ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER docker

WORKDIR /home/docker
