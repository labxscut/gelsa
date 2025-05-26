# Compiler and flags
CXX = g++
NVCC = /usr/local/cuda-12.3/bin/nvcc
CXXFLAGS = -std=c++14 -fPIC -I/usr/include/python3.10 -I../pybind11/include -I/usr/local/cuda-12.3/include
NVCCFLAGS = -Xcompiler -fPIC -ccbin /usr/bin/gcc-11 -std=c++14
LDFLAGS = -L/usr/lib/python3.10 -L/usr/local/cuda-12.3/lib64 -lpython3.10 -lcudart -shared
OPTFLAGS = -O3

# Targets
TARGET = ../lsa/compcore.so
OBJ = libcompcore.o
SRC = $(wildcard ./*.cpp)

all: $(TARGET)

$(TARGET): $(OBJ) $(SRC)
	$(CXX) $(CXXFLAGS) $(OPTFLAGS) $(SRC) $(OBJ) $(LDFLAGS) -o $(TARGET)

$(OBJ): compcore.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)

.PHONY: all clean