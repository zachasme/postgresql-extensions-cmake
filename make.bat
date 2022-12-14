rm -rf build

cmake -B        build -A x64 -DCMAKE_BUILD_TYPE=Release
cmake --build   build --config Release
cmake --install build --component Unspecified

ctest --test-dir build --output-on-failure --build-config Release
