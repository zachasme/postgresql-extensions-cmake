# Fresh build directory
rm -rf build
mkdir build

# Build and install
     cmake -B        build -DCMAKE_BUILD_TYPE=Release 
     cmake --build   build -- VERBOSE=1
sudo cmake --install build --component Unspecified

# Run tests
pushd build
ctest --output-on-failure --build-config Release
popd
