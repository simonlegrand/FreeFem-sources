cmake_minimum_required(VERSION 3.26)

# Prevent in-source builds
if (${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR "In-source builds are not allowed")
endif()

include(CMakePrintHelpers)
# Add the path containing FreeFEM CMake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake/modules)

### Build types
#
# Ensure non-empty (Debug) default build type for single-config generators
get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT isMultiConfig)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type")
endif()

set(FREEFEM_VERSION 4.16)
project(FreeFEM
  LANGUAGES C CXX
  VERSION ${FREEFEM_VERSION}
)

#include(ff_config_build_types)

include(ff_define_strversionnumber_library)
ff_define_strversionnumber_library()

option(ENABLE_FFCS "Build FreeFEM for use with FreeFem++-cs" OFF)
option(WITH_MPI "Activate MPI support" ON)

add_definitions(-DHAVE_CONFIG_H) # Probably useless, config.h always present

include(ff_configure_compilers)

include(ff_check_required_dependencies)

# ==============================================================================
# Ensure .exe and .dll are in the same directory to run the tests.
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  # Ensure it has not already been set by a parent project
  if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin-win32)
  endif()
endif()

### Setup installation variables
#  
include(ff_setup_install) # 
cmake_print_variables(CMAKE_INSTALL_RPATH)

### Dependencies search
#
if (WITH_MPI)
  find_package(MPI REQUIRED COMPONENTS CXX)
endif()

# md2edp
set(FF_MD2EDP_EXE_NAME md2edp)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/etc/tools)
# libff, lglib, libMesh, FreeFem++(-nw)
set(FF_EXE_NW_NAME FreeFem++-nw)
set(FF_LIBFF_NAME ff)
set(FF_LIBLG_NAME lglib)
#set(FF_LIBMESH_NAME Mesh)
set(FF_LIBS ${FF_LIBFF_NAME} ${FF_LIBLG_NAME})

### config.h library
#
# config.h is considered a build product. It is encapsulated into the include
# directory of an INTERFACE library (can have no source).
# The library is 'forward' declared to be used by other FF targets. But the
# config.h is configured at the end.
#
set(FF_CONFIG_H_LIB config_h_lib)
add_library(${FF_CONFIG_H_LIB} INTERFACE)
target_include_directories(${FF_CONFIG_H_LIB}
  INTERFACE ${CMAKE_CURRENT_BINARY_DIR}
)

# FF sources
add_subdirectory(${PROJECT_SOURCE_DIR}/src)

# Dynamically loadable plugins
set(FF_PLUGINS_LIST "")
add_subdirectory(${PROJECT_SOURCE_DIR}/plugin)

# Note: this call MUST be performed in the main CMake script
enable_testing()
# Examples are tests
add_subdirectory(${PROJECT_SOURCE_DIR}/examples)

# ### PETSc
# # Chercher les deux version réels et complexes
# find_package(PkgConfig REQUIRED)
# if (PETSC_DIR)
#   list(APPEND CMAKE_PREFIX_PATH ${PETSC_DIR})
#   pkg_search_module(PETSC IMPORTED_TARGET GLOBAL "PETSc>=3.22.0")
#   # TODO Assert it is a real version
  
#   # Remove PETSC_DIR to avoid pkg_search_module to find two times the same PETSc
#   list(REMOVE_ITEM CMAKE_PREFIX_PATH ${PETSC_DIR})
# endif()
# if (PETSC_COMPLEX_DIR)
#   list(APPEND CMAKE_PREFIX_PATH ${PETSC_COMPLEX_DIR})
#   pkg_search_module(PETSC_COMPLEX IMPORTED_TARGET GLOBAL "PETSc>=3.22.0")
#   # Assert it is a complex version
  
# endif()

# # TODO Assert that both versions have the same dependencies?

# # Check if PETSc has been compiled with dependencies
# #
# # Parse the value of the Libs.private keyword in petsc.pc returned as
# # PETSC_STATIC_LDFLAGS by pkg_search_module.
# set(PETSC_DEPS "FFTW;METIS;MUMPS")
# set(PETSC_DEPS_FOUND "")
# foreach(_dep ${PETSC_DEPS})
#   string(TOLOWER ${_dep} _dep_lower_case)
#   foreach(_flag ${PETSC_STATIC_LDFLAGS})
#     string(FIND ${_flag} ${_dep_lower_case} FOUND_${_dep})
#     if(NOT ${FOUND_${_dep}} EQUAL -1)
#       list(APPEND PETSC_DEPS_FOUND ${_dep})
#     endif()
#   endforeach()
# endforeach()
# list(REMOVE_DUPLICATES PETSC_DEPS_FOUND)

# message(STATUS "PETSc compiled with:")
# foreach(_dep_found ${PETSC_DEPS_FOUND})
#   message(STATUS "- ${_dep_found}")
# endforeach()

# FreeFEM install prefix for everything but bin and share
# TODO Why is it installed this way?
# Should it be different on MacOS?
#



# This variable is used in source code to locate primary freefem++.pref file.
# It must be know at build time. 
#set(FF_PREFIX_DIR ${CMAKE_INSTALL_PREFIX}/FreeFem++-nw.app/Contents/Resources)
set(FF_PREFIX_DIR ${FREEFEM_INSTALL_FULL_CONFIGDIR})
configure_file(${PROJECT_SOURCE_DIR}/cmake/freefem++.pref.in ${CMAKE_CURRENT_BINARY_DIR}/freefem++.pref)

# Run at the end, after dependencies detection
include(ff_configure_config_header)
ff_configure_config_header()

### Installation
#
# Remark: If generator is Xcode, installation is supposed to be done in Xcode
#
install(TARGETS
  ${FF_EXE_NW_NAME} ${FF_MD2EDP_EXE_NAME}
  RUNTIME DESTINATION "${FREEFEM_INSTALL_BINDIR}"
)

install(TARGETS ${FF_PLUGINS_LIST}  LIBRARY DESTINATION "${FREEFEM_INSTALL_PLUGINDIR}")
#install(TARGETS mydsl_lib   LIBRARY DESTINATION "${MYDSL_INSTALL_LIBDIR}")

# install(TARGETS
#   ${FF_EXE_NW_NAME}
#   BUNDLE DESTINATION .
#   RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#   LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#   ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/freefem++.pref
  DESTINATION ${FF_PREFIX_DIR})

install(DIRECTORY idp/
  DESTINATION "${FREEFEM_INSTALL_DATADIR}/idp"
  FILES_MATCHING PATTERN "*.idp"
)

install(DIRECTORY examples/
  DESTINATION "${FREEFEM_INSTALL_DATADIR}/examples"
  FILES_MATCHING
    PATTERN "*.edp"
    PATTERN  "*.md"
)

set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VERSION "${FREEFEM_VERSION}")
set(CPACK_VERBATIM_VARIABLES YES)
set(CPACK_PACKAGE_DIRECTORY "distribution")
set(CPACK_PACKAGE_VENDOR "LJLL")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_NAME}")
set(CPACK_MONOLITHIC_INSTALL TRUE)

# Needed by CPack DEB generator
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "frederic.hecht@sorbonne-universite.fr")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libopenblas0")

include(CPack)
