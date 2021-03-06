###############################################################################
# CMakeLists.txt

# Set the minimum required CMake version.
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# Set the project name.
project(MyProject)

# Declare configuration options.
option(BUILD_DOCS "Build documentation" ON)
option(BUILD_EXAMPLES "Build examples" ON)
option(BUILD_TESTS "Build unit tests" ON)

# Use C++14
add_compile_options(-std=c++14)
include_directories(include)

# Build the lib subdirectory.
add_subdirectory(lib)
add_subdirectory(tools)

# Optionally build documentation.
if (BUILD_DOCS)
  add_subdirectory(doc)
endif()

# Optionally build unit tests.
if (BUILD_TESTS)
  add_subdirectory(test)
endif()

# Optionally build examples.
if (BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()
