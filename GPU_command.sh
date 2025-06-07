#!/bin/bash

# Check if the OS is Ubuntu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    
    if [ "$ID" != "ubuntu" ]; then
        echo "Please execute this file using the Ubuntu 20.04, Ubuntu 22.04, or Ubuntu 24.04 operating systems."
        exit 1
    fi
else
    echo "Cannot determine OS. Please execute this file using Ubuntu 20.04, 22.04, or 24.04."
    exit 2
fi

# Install dependencies
apt-get update && apt-get install -y \
    wget \
    sudo \
    python3.8 \
    python3.8-dev \
    python3-pip
    
sudo apt-get update && sudo apt-get install -y lsb-release

sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
pip install scipy statsmodels pandas numpy argparse

# Get Ubuntu version
version_ubuntu=$(lsb_release -sr)

# Download appropriate CUDA keyring
if [[ "$version_ubuntu" == "20.04" ]]; then
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
elif [[ "$version_ubuntu" == "22.04" ]]; then
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb 
elif [[ "$version_ubuntu" == "24.04" ]]; then
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
else
    echo "Unsupported Ubuntu version. Please use Ubuntu 20.04, 22.04, or 24.04."
    exit 3
fi

# Install CUDA toolkit
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-6

# Clean up previous LSA installation
sudo pip uninstall -y lsa
sudo rm -rf /usr/local/lib/python3.8/dist-packages/lsa*
sudo rm -f /usr/local/bin/lsa_compute /usr/local/bin/m

# Build and install LSA
cd ./gelsa/

sudo rm -rf build/ dist/ lsa.egg-info/
cd ./Gpu_compcore/

/usr/local/cuda-12.6/bin/nvcc -Xcompiler -fPIC \
    -ccbin /usr/bin/gcc-9 \
    -std=c++14 \
    -c ./compcore.cu \
    -o ./libcompcore.o

g++ -std=c++14 -fPIC -shared \
    ./*.cpp \
    ./libcompcore.o \
    -I /usr/include/python3.8 \
    -L /usr/lib/python3.8 \
    -lpython3.8 \
    -I../pybind11/include \
    -I/usr/local/cuda-12.6/include \
    -L/usr/local/cuda-12.6/lib64 \
    -lcudart \
    -O3 -o ../lsa/compcore.so

cd ../
sudo pip install .
cd ../

echo "Installation completed successfully!"
echo "You can now run: lsa_compute test.txt result -d 10 -r 1 -s 20 -p theo"


#!/bin/bash

# apt-get update && apt-get install -y wget sudo python3.8 python3.8-dev python3-pip

# sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
# pip install scipy statsmodels pandas numpy argparse


# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
# sudo dpkg -i cuda-keyring_1.1-1_all.deb
# sudo apt-get update
# sudo apt-get -y install cuda-toolkit-12-3


# sudo pip uninstall lsa
# sudo rm -rf /usr/local/lib/python3.10/dist-packages/lsa-1.0.2-py3.8.egg
# sudo rm -f /usr/local/bin/lsa_compute /usr/local/bin/m

# cd ./gelsa/
# sudo rm -rf build/ dist/ lsa.egg-info/

# cd ./Cpu_compcore/

# /usr/local/cuda-12.3/bin/nvcc -Xcompiler -fPIC \
# -ccbin /usr/bin/gcc-11 \
# -std=c++14 \
# -c ./compcore.cu \
# -o ./libcompcore.o && 
# g++ -std=c++14 -fPIC -shared \
# ./*.cpp \
# ./libcompcore.o \
# -I /usr/include/python3.8 \
# -L /usr/lib/python3.8 \
# -lpython3.8 \
# -I../pybind11/include \
# -I/usr/local/cuda-12.3/include \
# -L/usr/local/cuda-12.3/lib64 \
# -lcudart \
# -O3 -o ../lsa/compcore.so

# cd ../
# sudo pip install .   # setup.py自动识别
# cd ../

# # python in_out_data.py
# lsa_compute test.txt result -d 10 -r 1 -s 20 -p theo














