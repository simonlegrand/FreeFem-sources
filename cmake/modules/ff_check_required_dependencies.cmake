# TODO Check whether m4, autotools are conditionned to the dependencies
# that need to use them.

# Check for unzip is not necessary since CMake can handle the decompression
# of zip (and other formats) with find(ARCHIVE EXTRACT INPUT ...)
# https://cmake.org/cmake/help/latest/command/file.html#archive-extract
set(ff_required_deps
  BISON
  FLEX
  Patch
  BLAS
  LAPACK
)

foreach(dep ${ff_required_deps})
  find_package(${dep} REQUIRED)
endforeach()
