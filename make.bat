:: Fresh build directory
rm -rf build
mkdir build

:: Build and install
cmake -B        build -A x64
cmake --build   build --config Release
cmake --install build --config Release --component Unspecified

:: Run tests
ctest --test-dir build --output-on-failure --build-config Release
