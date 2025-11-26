set -eu

LLVM_VERSION=20

wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh $LLVM_VERSION
sudo apt install -y libclang-${LLVM_VERSION}-dev clang-tools-${LLVM_VERSION} libomp-${LLVM_VERSION}-dev

# special case for LLVM 16
if [[ "${LLVM_VERSION}" == "16" ]]; then
    sudo rm -r /usr/lib/clang/16*
    sudo ln -s /usr/lib/llvm-16/lib/clang/16 /usr/lib/clang/16
fi