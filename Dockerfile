FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /gelsa

# # Copy source code
COPY . .

# Build C++ component
# RUN bash docker_cpu.sh

# docker build -t my-gelsa .
# docker run -it --rm my-gelsa
# docker run -it --rm --gpus all my-gelsa
