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


apt-get update && apt-get install -y wget sudo python3 python3-dev python3-pip
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
# echo "$py"

if [[ "$version_ubuntu" == "24.04" ]]; then
    sudo pip uninstall --break-system-packages lsa
    pip install --break-system-packages scipy statsmodels pandas numpy argparse
else
    sudo pip uninstall -y lsa
fi

# sudo rm -rf /usr/local/lib/python$py/dist-packages/lsa*
sudo rm -f /usr/local/bin/lsa_compute /usr/local/bin/m

cd ./gelsa/
sudo rm -rf build/ dist/ lsa.egg-info/
cd ./Cpu_compcore/


if [[ "$version_ubuntu" == "24.04" ]]; then
    g++ -std=c++11 -fPIC -shared \
    ./*.cpp \
    -I /usr/include/python3.12 \
    -L /usr/lib/python3.12 \
    -lpython3.12 \
    -I../pybind11/include \
    -O3 -o ../lsa/compcore.so

elif [[ "$version_ubuntu" == "22.04" ]]; then
     g++ -std=c++11 -fPIC -shared \
    ./*.cpp \
    -I /usr/include/python3.10 \
    -L /usr/lib/python3.10 \
    -lpython3.10 \
    -I../pybind11/include \
    -O3 -o ../lsa/compcore.so

elif [[ "$version_ubuntu" == "20.04" ]]; then
    g++ -std=c++11 -fPIC -shared \
    ./*.cpp \
    -I /usr/include/python3.8 \
    -L /usr/lib/python3.8 \
    -lpython3.8 \
    -I../pybind11/include \
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
