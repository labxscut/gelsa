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

apt-get update && apt-get install -y wget sudo python3 python3-pip
sudo apt-get update && sudo apt-get install -y lsb-release
version_ubuntu=$(lsb_release -sr)

if [[ "$version_ubuntu" != "20.04" && "$version_ubuntu" != "22.04" && "$version_ubuntu" != "24.04" ]]; then
    echo "Please execute this file using Ubuntu 20.04, 22.04, or 24.04."
    exit 3
fi

if [[ "$version_ubuntu" == "24.04" ]]; then
    pip install --break-system-packages scipy
    pip install --break-system-packages statsmodels
    pip install --break-system-packages pandas
    pip install --break-system-packages numpy
    pip install --break-system-packages argparse
else
    pip install scipy statsmodels pandas numpy argparse
fi

# py=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d. -f1-2)

if [[ "$version_ubuntu" == "24.04" ]]; then
    sudo pip uninstall --break-system-packages lsa
    pip install --break-system-packages scipy statsmodels pandas numpy argparse
else
    sudo pip uninstall -y lsa
fi

# sudo rm -rf /usr/local/lib/python3.8/dist-packages/lsa*
sudo rm -f /usr/local/bin/lsa_compute /usr/local/bin/m

cd ./gelsa/
sudo rm -rf build/ dist/ lsa.egg-info/
cd ./Gpu_compcore/

# Download appropriate CUDA keyring
if [[ "$version_ubuntu" == "24.04" ]]; then   # 12.5.1
    pip install --break-system-packages scipy statsmodels pandas numpy argparse
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-12-5

    /usr/local/cuda-12.5/bin/nvcc -Xcompiler -fPIC \
        -ccbin /usr/bin/gcc \
        -std=c++14 \
        -c ./compcore.cu \
        -o ./libcompcore.o&&
        g++ -std=c++14 -fPIC -shared \
        ./*.cpp \
        ./libcompcore.o \
        -I /usr/include/python3.12 \
        -L /usr/lib/python3.12 \
        -lpython3.12 \
        -I../pybind11/include \
        -I/usr/local/cuda-12.5/include \
        -L/usr/local/cuda-12.5/lib64 \
        -lcudart \
        -O3 -o ../lsa/compcore.so

elif [[ "$version_ubuntu" == "22.04" ]]; then   # 11.7.0
    sudo apt-get install -y gnupg2 gnupg1 software-properties-common
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
    sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
    sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /"
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-11-7

    /usr/local/cuda-11.7/bin/nvcc -Xcompiler -fPIC \
        -ccbin /usr/bin/gcc \
        -std=c++14 \
        -c ./compcore.cu \
        -o ./libcompcore.o&&
        g++ -std=c++14 -fPIC -shared \
        ./*.cpp \
        ./libcompcore.o \
        -I /usr/include/python3.10 \
        -L /usr/lib/python3.10 \
        -lpython3.10 \
        -I../pybind11/include \
        -I/usr/local/cuda-11.7/include \
        -L/usr/local/cuda-11.7/lib64 \
        -lcudart \
        -O3 -o ../lsa/compcore.so

elif [[ "$version_ubuntu" == "20.04" ]]; then   # 11.0.3
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
    sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda-repo-ubuntu2004-11-0-local_11.0.3-450.51.06-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu2004-11-0-local_11.0.3-450.51.06-1_amd64.deb
    sudo apt-key add /var/cuda-repo-ubuntu2004-11-0-local/7fa2af80.pub
    sudo apt-get update
    sudo apt-get install -y cuda-toolkit-11-0

    /usr/local/cuda-11.0/bin/nvcc -Xcompiler -fPIC \
        -ccbin /usr/bin/gcc \
        -std=c++14 \
        -c ./compcore.cu \
        -o ./libcompcore.o&&
        g++ -std=c++14 -fPIC -shared \
        ./*.cpp \
        ./libcompcore.o \
        -I /usr/include/python3.8 \
        -L /usr/lib/python3.8 \
        -lpython3.8 \
        -I../pybind11/include \
        -I/usr/local/cuda-11.0/include \
        -L/usr/local/cuda-11.0/lib64 \
        -lcudart \
        -O3 -o ../lsa/compcore.so
        
fi

cd ../
if [[ "$version_ubuntu" == "24.04" ]]; then
    sudo pip install --break-system-packages .   # setup.py自动识别
    pip install --break-system-packages scipy statsmodels pandas numpy argparse
else
    sudo pip install .
fi
cd ../

echo "Installation completed successfully!"
echo "You can now run: sudo lsa_compute test.txt result -d 10 -r 1 -s 20 -p theo"
