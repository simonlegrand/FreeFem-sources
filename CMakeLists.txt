cmake_minimum_required(VERSION 3.22)

# Add the path containing FreeFEM CMake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake/modules)

include(ff_single_config_build_types)

project(FreeFEM LANGUAGES C CXX)

include(ff_multi_config_build_types)

set(FREEFEM_VERSION 4.15)

include(ff_define_strversionnumber_library)
ff_define_strversionnumber_library()

option(ENABLE_FFCS "Build FreeFEM for use with FreeFem++-cs" OFF)
option(WITH_MPI "Activate MPI support" ON)
add_definitions(-DCHECK_KN)
add_definitions(-DHAVE_CONFIG_H)

include(ff_check_required_dependencies)

if (WITH_MPI)
  find_package(MPI REQUIRED COMPONENTS CXX)
endif()

# md2edp
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/etc/tools)
# libff, lglib, libMesh, FreeFem++(-nw)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src)
# Dynamically loaded plugins
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/plugin)

# Note: this call MUST be performed in the main CMake script
enable_testing()
# Examples are tests
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/examples)

# Chercher les deux version réels et complexes
find_package(PkgConfig REQUIRED)
if (PETSC_DIR)
  list(APPEND CMAKE_PREFIX_PATH ${PETSC_DIR})
  pkg_search_module(PETSC IMPORTED_TARGET GLOBAL "PETSc>=3.22.0")
  # TODO Assert it is a real version
  
  # Remove PETSC_DIR to avoid pkg_search_module to find two times the same PETSc
  list(REMOVE_ITEM CMAKE_PREFIX_PATH ${PETSC_DIR})
endif()
if (PETSC_COMPLEX_DIR)
  list(APPEND CMAKE_PREFIX_PATH ${PETSC_COMPLEX_DIR})
  pkg_search_module(PETSC_COMPLEX IMPORTED_TARGET GLOBAL "PETSc>=3.22.0")
  # Assert it is a complex version
  
endif()

# TODO Assert that both versions have the same dependencies?

# Check if PETSc has been compiled with dependencies
#
# Parse the value of the Libs.private keyword in petsc.pc returned as
# PETSC_STATIC_LDFLAGS by pkg_search_module.
set(PETSC_DEPS "FFTW;METIS;MUMPS")
set(PETSC_DEPS_FOUND "")
foreach(_dep ${PETSC_DEPS})
  string(TOLOWER ${_dep} _dep_lower_case)
  foreach(_flag ${PETSC_STATIC_LDFLAGS})
    string(FIND ${_flag} ${_dep_lower_case} FOUND_${_dep})
    if(NOT ${FOUND_${_dep}} EQUAL -1)
      list(APPEND PETSC_DEPS_FOUND ${_dep})
    endif()
  endforeach()
endforeach()
list(REMOVE_DUPLICATES PETSC_DEPS_FOUND)

message(STATUS "PETSc compiled with:")
foreach(_dep_found ${PETSC_DEPS_FOUND})
  message(STATUS "- ${_dep_found}")
endforeach()

# Should be run at the end, after dependencies detection
include(ff_configure_config_header)
ff_configure_config_header()

# Once dependencies found, try to locate them by first looking in PETSC_DIR and
# PETSC_COMPLEX_DIR. 
