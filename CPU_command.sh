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

apt-get update && apt-get install -y wget sudo
sudo apt-get update && sudo apt-get install -y lsb-release

version_ubuntu=$(lsb_release -sr)
if [[ "$version_ubuntu" != "20.04" && "$version_ubuntu" != "22.04" && "$version_ubuntu" != "24.04" ]]; then
    echo "Please execute this file using Ubuntu 20.04, 22.04, or 24.04."
    exit 3
fi

deactivate && conda deactivate # 关闭所有虚拟环境，此软件安装会创建一个虚拟环境gelsa_env，软件就在这个环境中运行
rm -rf gelsa_env
apt-get update
apt-get install -y software-properties-common && add-apt-repository -y ppa:deadsnakes/ppa
apt-get update

if [[ "$version_ubuntu" == "24.04" ]]; then
    apt-get install -y python3.12 python3.12-dev python3.12-venv python3-pip
    python3.12 -m venv gelsa_env

elif [[ "$version_ubuntu" == "22.04" ]]; then
    apt-get install -y python3.10 python3.10-dev python3.10-venv python3-pip
    python3.10 -m venv gelsa_env
elif [[ "$version_ubuntu" == "20.04" ]]; then
    apt-get install -y python3.8 python3.8-dev python3.8-venv python3-pip
    python3.8 -m venv gelsa_env
fi

source gelsa_env/bin/activate
pip install --upgrade pip
pip install scipy statsmodels pandas numpy argparse
py=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d. -f1-2)
echo "$py"

pip uninstall -y lsa
cd ./gelsa/
sudo rm -rf build/ dist/ lsa.egg-info/
cd ./Cpu_compcore/

g++ -std=c++11 -fPIC -shared \
    ./*.cpp \
    -I /usr/include/python$py \
    -L /usr/lib/python$py \
    -lpython$py \
    -I../pybind11/include \
    -O3 -o ../lsa/compcore.so

cd ../
pip install . 
cd ../

deactivate

echo "Installation completed successfully!"
echo "Please activate the virtual environment 'gelsa_env' first, run the command: source gelsa_env/bin/activate"
echo "After activate the virtual environment 'gelsa_env', You can now run: lsa_compute test.txt result -d 10 -r 1 -s 20 -p theo"

