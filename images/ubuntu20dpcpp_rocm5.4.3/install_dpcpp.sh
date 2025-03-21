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
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
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

git clone https://github.com/intel/llvm --depth=1 -b v6.0.0

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