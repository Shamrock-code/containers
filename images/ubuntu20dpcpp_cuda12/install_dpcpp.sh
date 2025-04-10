set -e

mkdir compilers_gits
mkdir compilers

###################################
## DPC++ (requirement)
###################################
#update cmake
sudo apt-get update
sudo apt-get install -y ca-certificates gpg wget
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
sudo apt-get update
sudo rm /usr/share/keyrings/kitware-archive-keyring.gpg
sudo apt-get install -y kitware-archive-keyring
sudo apt-get update
sudo apt-get install -y cmake


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