#!/bin/bash

apt-get update && apt-get install -y wget sudo python3.10 python3.10-dev python3-pip
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
pip install scipy statsmodels pandas numpy argparse


wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-3


sudo pip uninstall lsa
sudo rm -rf /usr/local/lib/python3.10/dist-packages/lsa-1.0.2-py3.10.egg
sudo rm -f /usr/local/bin/lsa_compute /usr/local/bin/m

cd ./gelsa/
sudo rm -rf build/ dist/ lsa.egg-info/

cd ./Cpu_compcore/

make

cd ../
sudo pip install .   # setup.py自动识别
cd ../

python in_out_data.py
lsa_compute test.txt result -d 10 -r 1 -s 50 -p theo -T 0.1
