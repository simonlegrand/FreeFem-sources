cmake_minimum_required(VERSION 3.22)

set(FF_PROJECT_NAME FreeFEM)
project(${FF_PROJECT_NAME} LANGUAGES C CXX Fortran)

set(FREEFEM_VERSION 4.15)

# Add the path containing cmake modules
# Note: this line cannot be put in the body of ff_configure_cmake
# because ff_configure_cmake is searched in the right repository 
# thanks to this line
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake/modules)

# Must be cached to avoid recompilation at each reconfiguration
include(ff_define_strversionnumber_library)
ff_define_strversionnumber_library()
# Check for required dependecies

include(ff_configure_compilers)
include(ff_check_required_dependencies)
include(ff_configure_config_header)



#ff_configure_compilers()
ff_configure_config_header()
# ff_configure_cmake()
#ff_configure_compilers()
#ff_write_config_file()
# ff_configure_thirdparty()

# ff_write_config_file()




# creation of "make test" command
# Note: this call MUST be performed in the main CMake script
enable_testing()

add_subdirectory(src)

find_package(PkgConfig REQUIRED)

if (PETSc_DIR)
  list(APPEND CMAKE_PREFIX_PATH ${PETSc_DIR})
endif()
pkg_search_module(PETSC REQUIRED IMPORTED_TARGET GLOBAL "PETSc>=3.22.0")
message(STATUS "Found PETSc ${PETSC_VERSION}")

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

# list(FILTER PETSC_STATIC_LDFLAGS INCLUDE REGEX "fftw")
# if(_)
#   message(STATUS "✓ FFTW appears in PETSc link line: ${_libs}")
# endif()

# include(CheckSourceCompiles)
# set(CMAKE_REQUIRED_INCLUDES "/home/slegrand/Documents/ALPINES/PETSc/install/include")
# set(CMAKE_REQUIRED_LIBRARIES PkgConfig::PETSC)

# message(STATUS "${CMAKE_REQUIRED_INCLUDES}")
# set(PETSC_WITH_FFTW )
# set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
# check_source_compiles(C
#   "
# #ifdef PETSC_HAVE_FFTW
#        int main(void){return 0;}
# #endif
#      "
#   PETSC_WITH_FFTW
# )

# if(PETSC_WITH_FFTW)
#   message(STATUS "✓ PETSc headers confirm FFTW support")
# else()
#   message(STATUS "Pas fftw")
# endif()
#target_link_libraries(ex1 PkgConfig::PETSC)

# add_subdirectory(examples)


