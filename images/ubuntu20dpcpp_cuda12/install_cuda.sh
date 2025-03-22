set -eu

mkdir -p /opt/cuda
wget --progress=bar:force -O cuda.sh https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda_12.8.1_570.124.06_linux.run
sudo sh ./cuda.sh --override --silent --toolkit --no-man-page --no-drm --no-opengl-libs --installpath=/opt/cuda || true
echo "CUDA Version 12.8.1" | sudo tee /opt/cuda/version.txt
rm cuda.sh