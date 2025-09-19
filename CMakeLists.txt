cmake_minimum_required(VERSION 3.23)
include(CMakePrintHelpers)
# Add the path containing FreeFEM CMake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake/modules)

### Build types

# Ensure non-empty (Debug) default build type for single-config generators
get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT isMultiConfig)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type")
endif()
#include(ff_single_config_build_types)

project(FreeFEM LANGUAGES C CXX)

#include(ff_config_build_types)

set(FREEFEM_VERSION 4.15)
set(CMAKE_POSITION_INDEPENDENT_CODE 1)

include(ff_define_strversionnumber_library)
ff_define_strversionnumber_library()

option(ENABLE_FFCS "Build FreeFEM for use with FreeFem++-cs" OFF)
option(WITH_MPI "Activate MPI support" ON)
add_definitions(-DCHECK_KN)
add_definitions(-DHAVE_CONFIG_H)

include(ff_check_required_dependencies)

### Portable install RPATH settings
#
# Must be done before targets creation
#
include(GNUInstallDirs)
if(APPLE)
  set(base @loader_path)
else()
  set(base $ORIGIN)
endif()

file(RELATIVE_PATH relDir
  ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR}
  ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
)
set(CMAKE_INSTALL_RPATH ${base} ${base}/${relDir})
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
set(FF_LIBS ${FF_LIBFF_NAME} ${FF_LIBLG_NAME} ${FF_LIBMESH_NAME})
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
# This variable should be reset at install time to take into account
# the possible use of --prefix option.
#
# This variable is used in source code to locate primary freefem++.pref file.
# It must be know at build time. 
set(FF_PREFIX_DIR ${CMAKE_INSTALL_PREFIX}/FreeFem++-nw.app/Contents/Resources)

# Should be run at the end, after dependencies detection
include(ff_configure_config_header)
ff_configure_config_header()

# Once dependencies found, try to locate them by first looking in PETSC_DIR and
# PETSC_COMPLEX_DIR.

### Installation

# Explicitly set DOCDIR location each time, to avoid other calls to project()
# to change it
set(CMAKE_INSTALL_DOCDIR ${CMAKE_INSTALL_DATAROOTDIR}/doc/${PROJECT_NAME})

# To respect FHS recommandations
if( NOT CMAKE_INSTALL_PREFIX OR ENV{CMAKE_INSTALL_PREFIX})
  if(NOT WIN32 AND CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    set(CMAKE_INSTALL_PREFIX "/opt/${PROJECT_NAME}")
  endif()
endif()

### Installation
install(TARGETS
  ${FF_EXE_NW_NAME}
  BUNDLE DESTINATION .
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

# set(genex "$<TARGET_FILE_DIR:${FF_EXE_NW_NAME}>")
# add_custom_target(printGenex
#   COMMENT "Result of generator expression:"
#   COMMAND ${CMAKE_COMMAND} -E echo "${genex}"
#   VERBATIM)

file(GLOB FF_IDP_FILES
  idp/*.idp)

if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
  include(platform/linux/CMakeLists.txt)
elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  include(install_darwin)
endif()

# Trick to get the PROJECT_SOURCE_DIR set in the install script and
# evaluate FF_PREFIX_DIR at install time.
# See https://stackoverflow.com/questions/73815300/how-do-i-get-project-root-dir-in-the-cmake-install-code-section
string(CONFIGURE [[
  set(PROJECT_SOURCE_DIR "@PROJECT_SOURCE_DIR@")
  set(FF_PREFIX_DIR "@FF_PREFIX_DIR@")
  message(STATUS "PROJECT_SOURCE_DIR: ${PROJECT_SOURCE_DIR}")
  message(STATUS "FF_PREFIX_DIR: ${FF_PREFIX_DIR}")
  configure_file(${PROJECT_SOURCE_DIR}/cmake/freefem++.pref.in ${FF_PREFIX_DIR}/etc/freefem++.pref)
  ]] install_script @ONLY)

install(CODE "${install_script}")

set(CPACK_VERBATIM_VARIABLES YES)
set(CPACK_PACKAGE_DIRECTORY distribution)
set(CPACK_PACKAGE_VENDOR "LJLL")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${FREEFEM_VERSION}")
set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY ${CPACK_PACKAGE_NAME})
set(CPACK_MONOLITHIC_INSTALL TRUE)

include(CPack)

# set(CPACK_PACKAGE_VERSION "4.15")
# set(CPACK_PACKAGE_CONTACT "support@yourcompany.com")
