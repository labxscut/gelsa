#!/bin/bash

apt-get update && apt-get install -y wget sudo 

# ubuntu20.04
# 11.0.2
# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
# sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
# wget https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda-repo-ubuntu2004-11-0-local_11.0.3-450.51.06-1_amd64.deb
# sudo dpkg -i cuda-repo-ubuntu2004-11-0-local_11.0.3-450.51.06-1_amd64.deb
# sudo apt-key add /var/cuda-repo-ubuntu2004-11-0-local/7fa2af80.pub
# sudo apt-get update
# sudo apt-get install -y cuda-toolkit-11-0

# ubuntu22.04
# 11.7.0
# sudo apt-get install -y gnupg2 gnupg1 software-properties-common
# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
# sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
# sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
# sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /"
# sudo apt-get update
# sudo apt-get -y install cuda-toolkit-11-7

# ubuntu24.04
# 12.5.1
# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
# sudo dpkg -i cuda-keyring_1.1-1_all.deb
# sudo apt-get update
# sudo apt-get -y install cuda-toolkit-12-5