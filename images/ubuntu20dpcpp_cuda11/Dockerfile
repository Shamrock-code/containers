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

RUN mkdir compilers_gits
RUN mkdir compilers

###################################
## DPC++ (requirement)
###################################
#update cmake
RUN sudo apt-get update
RUN sudo apt-get install -y ca-certificates gpg wget
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
RUN sudo apt-get update
RUN sudo rm /usr/share/keyrings/kitware-archive-keyring.gpg
RUN sudo apt-get install -y kitware-archive-keyring
RUN sudo apt-get update
RUN sudo apt-get install -y cmake

COPY install_cuda.sh /opt/src/scripts/install_cuda.sh
RUN sh /opt/src/scripts/install_cuda.sh

#esimd requirement
RUN sudo apt install -y libva-dev libffi-dev libtool

#OpenCL requirement
RUN sudo apt install -y clinfo intel-opencl-icd opencl-headers

#check clinfo
RUN clinfo

###################################
## DPC++
###################################
WORKDIR /home/docker/compilers_gits

RUN git clone https://github.com/intel/llvm -b 2024-WW14

WORKDIR /home/docker/compilers_gits/llvm

# configure dpcpp
RUN CUDA_LIB_PATH=~/opt/cuda/lib64/stubs \
        python3 buildbot/configure.py \
        --llvm-external-projects compiler-rt \
            --cuda \
            --cmake-opt="-DCMAKE_INSTALL_PREFIX=/home/docker/compilers/DPCPP" \
            --cmake-opt="-DCUDA_TOOLKIT_ROOT_DIR=~/opt/cuda" \

WORKDIR /home/docker/compilers_gits/llvm/build

RUN ninja all tools/libdevice/libsycldevice
RUN ninja install

WORKDIR /home/docker

RUN rm -rf compilers_gits