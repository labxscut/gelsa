#!/bin/bash

apt-get update && apt-get install -y wget sudo python3 python3-pip
sudo apt-get update && sudo apt-get install -y lsb-release

version_ubuntu=$(lsb_release -sr)

if [[ "$version_ubuntu" == "24.04" ]]; then    
    pip install --break-system-packages scipy
    pip install --break-system-packages statsmodels
    pip install --break-system-packages pandas
    pip install --break-system-packages numpy
    pip install --break-system-packages argparse
else
    pip install scipy statsmodels pandas numpy argparse
fi
py=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d. -f1-2)
echo "$py"

if [[ "$version_ubuntu" == "24.04" ]]; then
    sudo pip uninstall --break-system-packages lsa
    pip install --break-system-packages scipy statsmodels pandas numpy argparse
else
    sudo pip uninstall -y lsa
fi

sudo rm -rf /usr/local/lib/python3.8/dist-packages/lsa*
sudo rm -f /usr/local/bin/lsa_compute /usr/local/bin/m

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
if [[ "$version_ubuntu" == "24.04" ]]; then
    sudo pip install --break-system-packages .   # setup.py自动识别
    pip install --break-system-packages scipy statsmodels pandas numpy argparse
else
    sudo pip install .
fi
cd ../

echo "Installation completed successfully!"
echo "You can now run: sudo lsa_compute test.txt result -d 10 -r 1 -s 20 -p theo"
