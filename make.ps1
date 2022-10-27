# Fresh build directory
Remove-Item -Path build -Recurse

# Build and install
cmake -B        build -A x64 -DCMAKE_BUILD_TYPE=Release
cmake --build   build --config Release
cmake --install build --config Release --component Unspecified

# Run tests
ctest --test-dir build --output-on-failure --build-config Release
