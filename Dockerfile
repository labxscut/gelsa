FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /gelsa

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    sudo \
    python3.8 \
    python3.8-dev \
    python3-pip

# Set Python 3.8 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Install Python dependencies
RUN pip install --no-cache-dir scipy statsmodels pandas numpy argparse

# Clean up any existing installations
RUN if pip list | grep lsa; then pip uninstall -y lsa; fi && \
    rm -rf /usr/local/lib/python3.8/dist-packages/lsa* && \
    rm -f /usr/local/bin/lsa_compute /usr/local/bin/m

# Copy source code
COPY . .

# Build C++ component
RUN cd ./gelsa/Cpu_compcore/ && \
    g++ -std=c++14 -fPIC -shared \
    ./*.cpp \
    -I /usr/include/python3.8 \
    -L /usr/lib/python3.8 \
    -lpython3.8 \
    -I../pybind11/include \
    -O3 -o ../lsa/compcore.so

# Install Python package
RUN cd ./gelsa && \
    pip install --no-cache-dir . && \
    cd .. && \
    python in_out_data.py

# docker build -t my-gelsa .
# docker run -it --rm my-gelsa

# lsa_compute test.txt result -d 10 -r 1 -s 50 -p theo -T 0.1
# lsa_compute test.txt result -d 10 -r 1 -s 50 -p ddlsa -T 0.1
# lsa_compute test.txt result -d 10 -r 1 -s 50 -p perm -T 0.1
# lsa_compute test.txt result -d 10 -r 1 -s 50 -p stlta -T 0.1
# lsa_compute test.txt result -d 10 -r 1 -s 50 -p bblsa -T 0.1