###############################################################################
# CMakeLists.txt

# Set the minimum required CMake version.
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# Set the project name.
project(MyProject)

# Declare configuration options.
option(BUILD_DOCS "Build documentation" ON)
option(BUILD_TESTS "Build unit tests" ON)

# Build the lib subdirectory.
add_subdirectory(lib)

# Optionally build documentation.
if (BUILD_DOCS)
  add_subdirectory(doc)
endif()

# Optionally build unit tests.
if (BUILD_TESTS)
  add_subdirectory(test)
endif()

