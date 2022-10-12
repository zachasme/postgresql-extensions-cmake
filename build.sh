rm -rf build
mkdir build

cmake -B build -A x64
cmake --build build --config Release
cmake --install build

ctest --test-dir build --output-on-failure --build-config Release
