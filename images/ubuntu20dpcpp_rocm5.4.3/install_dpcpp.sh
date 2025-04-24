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
python3 buildbot/configure.py \
        --llvm-external-projects compiler-rt \
        --hip \
        --cmake-opt="-DCMAKE_INSTALL_PREFIX=/home/docker/compilers/DPCPP" \
        --cmake-opt="-DSYCL_BUILD_PI_HIP_ROCM_DIR=/opt/rocm"

cd /home/docker/compilers_gits/llvm/build

ninja 
ninja install

cd /home/docker

rm -rf compilers_gits

echo "int main() { return 0; }" > main.cpp
export LD_LIBRARY_PATH=/home/docker/compilers/DPCPP/lib:$LD_LIBRARY_PATH
/home/docker/compilers/DPCPP/bin/clang++ -fsycl -fsycl-targets=amdgcn-amd-amdhsa -Xsycl-target-backend --offload-arch=gfx906 --rocm-path=/opt/rocm main.cpp
rm main.cpp
rm a.out