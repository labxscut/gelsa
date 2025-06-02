#!/bin/bash

apt-get update && apt-get install -y wget sudo 
apt-get update && apt-get install -y wget sudo python3.8 python3.8-dev python3-pip
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
pip install scipy statsmodels pandas numpy argparse

sudo pip uninstall lsa
sudo rm -rf /usr/local/lib/python3.8/dist-packages/lsa-1.0.2-py3.8.egg
sudo rm -f /usr/local/bin/lsa_compute /usr/local/bin/m

cd ./gelsa/
sudo rm -rf build/ dist/ lsa.egg-info/

cd ./Cpu_compcore/


g++ -std=c++14 -fPIC -shared \
./*.cpp \
-I /usr/include/python3.8 \
-L /usr/lib/python3.8 \
-lpython3.8 \
-I../pybind11/include \
-O3 -o ../lsa/compcore.so

cd ../
sudo pip install .   # setup.py自动识别
cd ../

# python in_out_data.py
lsa_compute test.txt result -d 10 -r 1 -s 20 -p theo
