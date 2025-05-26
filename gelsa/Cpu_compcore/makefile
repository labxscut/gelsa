# Compiler and flags
CXX := g++
CXXFLAGS := -std=c++14 -fPIC -O3
INCLUDES := -I/usr/include/python3.10 -I../pybind11/include
LIBS := -L/usr/lib/python3.10 -lpython3.10

# Target and source files
TARGET := ../lsa/compcore.so
SRCS := $(wildcard ./*.cpp)
OBJS := $(SRCS:.cpp=.o)

# Build rules
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -shared $^ $(LIBS) -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean