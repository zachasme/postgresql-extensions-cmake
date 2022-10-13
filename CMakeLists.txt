# Almost all CMake files should start with this
# You should always specify a range with the newest
# and oldest tested versions of CMake. This will ensure
# you pick up the best policies.

# FetchContent_MakeAvailable in version 3.14
cmake_minimum_required(VERSION 3.14..3.24)

if(POLICY CMP0135)
  # Set the timestamps of all extracted contents to the time of the extraction
  cmake_policy(SET CMP0135 NEW)
endif()

# This is your project statement. You should always list languages;
# Listing the version is nice here since it sets lots of useful variables
project(
  postgresql-extensions-cmake
  VERSION 1.0.0
  LANGUAGES C
)

# If you set any CMAKE_ variables, that can go here.
# (But usually don't do this, except maybe for C++ standard)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Find packages go here.
find_package(PostgreSQL REQUIRED)

# You should usually split this into folders, but this is a simple example

# https://cliutils.gitlab.io/modern-cmake/chapters/testing.html
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  include(CTest)
endif()

add_subdirectory(extension_basic)
add_subdirectory(extension_dependant)
