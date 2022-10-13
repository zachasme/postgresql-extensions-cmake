# Fresh build directory
rm -rf build
mkdir build

# Build and install
cmake -B build
cmake --build build --config Release
sudo cmake --install build --config Release

# Run tests
ctest --test-dir build --output-on-failure --build-config Release
