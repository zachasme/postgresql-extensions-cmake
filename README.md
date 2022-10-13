# postgresql-extensions-cmake

[![test-linux](https://github.com/zachasme/postgresql-extensions-cmake/workflows/test-linux/badge.svg)](https://github.com/zachasme/postgresql-extensions-cmake/actions)
[![test-macos](https://github.com/zachasme/postgresql-extensions-cmake/workflows/test-macos/badge.svg)](https://github.com/zachasme/postgresql-extensions-cmake/actions/workflows/test-macos.yml)
[![test-windows](https://github.com/zachasme/postgresql-extensions-cmake/workflows/test-windows/badge.svg)](https://github.com/zachasme/postgresql-extensions-cmake/actions/workflows/test-windows.yml)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

```bash
# Generate native build system
cmake -B build

# Build extension(s)
cmake --build build --config Release

# Install (might require sudo)
cmake --install build --config Release

# Test (might require running server)
ctest --test-dir build --output-on-failure --build-config Release
```
