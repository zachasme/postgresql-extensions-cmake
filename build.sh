rm -rf build
mkdir build

cmake -B build .
cmake --build build --config Release
cmake --install build