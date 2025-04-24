set -e

mkdir compilers_gits
mkdir compilers

###################################
## DPC++ (requirement)
###################################
#update cmake
sudo apt-get update
sudo pip3 install cmake==3.31.6

#esimd requirement
sudo apt install -y libva-dev libffi-dev libtool

#OpenCL requirement
sudo apt install -y clinfo intel-opencl-icd opencl-headers

#check clinfo
clinfo

###################################
## DPC++
###################################
cd /home/docker/compilers_gits

git clone https://github.com/intel/llvm --depth=1 -b v6.0.1

cd /home/docker/compilers_gits/llvm

# configure dpcpp
CUDA_LIB_PATH=/opt/cuda/lib64/stubs \
        python3 buildbot/configure.py \
            --llvm-external-projects compiler-rt \
            --cuda \
            --cmake-opt="-DCMAKE_INSTALL_PREFIX=/home/docker/compilers/DPCPP" \
            --cmake-opt="-DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda" 

cd /home/docker/compilers_gits/llvm/build

ninja -k0 all lib/all tools/libdevice/libsycldevice
ninja -k0 install

cd /home/docker

rm -rf compilers_gits

echo "int main() { return 0; }" > main.cpp
export LD_LIBRARY_PATH=/home/docker/compilers/DPCPP/lib:$LD_LIBRARY_PATH
/home/docker/compilers/DPCPP/bin/clang++ -fsycl -fsycl-targets=nvidia_gpu_sm_50 main.cpp
rm main.cpp
rm a.out