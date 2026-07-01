# cmake/ff_setup_install.cmake
#
# After including this file, the following CACHE variables exist:
#
#   FREEFEM_INSTALL_BINDIR        - executable
#   FREEFEM_INSTALL_LIBDIR        - shared library
#   FREEFEM_INSTALL_INCLUDEDIR    - C++ public headers
#   FREEFEM_INSTALL_PLUGINDIR     - runtime-loadable plugins
#   FREEFEM_INSTALL_DATADIR       - idps & arch-independent data
#   FREEFEM_INSTALL_CONFIGDIR     - configuration file freefem++.pref
#
# And their absolute counterparts (FREEFEM_INSTALL_FULL_*).
# Include now the install script to get the FREEFEM_INSTALL_* variables used to
# configure FF_PREFIX_DIR
#
# For RPATH supporting plateforms, CMAKE_INSTALL_RPATH is set to lib and plugins
# directories relative to the executables.

include(GNUInstallDirs)

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  include("${CMAKE_CURRENT_LIST_DIR}/ff_setup_install_linux.cmake")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  include("${CMAKE_CURRENT_LIST_DIR}/ff_setup_install_darwin.cmake")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  include("${CMAKE_CURRENT_LIST_DIR}/ff_setup_install_windows.cmake")
else()
  message(WARNING "Unknown platform '${CMAKE_SYSTEM_NAME}', falling back to Linux layout")
  include("${CMAKE_CURRENT_LIST_DIR}/ff_setup_install_linux.cmake")
endif()

# Absolute paths
foreach(_comp BINDIR LIBDIR INCLUDEDIR PLUGINDIR DATADIR CONFIGDIR)
    if(NOT IS_ABSOLUTE "${FREEFEM_INSTALL_${_comp}}")
        set(FREEFEM_INSTALL_FULL_${_comp}
            "${CMAKE_INSTALL_PREFIX}/${FREEFEM_INSTALL_${_comp}}")
    else()
        set(FREEFEM_INSTALL_FULL_${_comp} "${FREEFEM_INSTALL_${_comp}}")
    endif()
endforeach()

message(STATUS "[FreeFEM] Install layout (${CMAKE_SYSTEM_NAME}):")
message(STATUS "  Binaries  : ${FREEFEM_INSTALL_FULL_BINDIR}")
message(STATUS "  Libraries : ${FREEFEM_INSTALL_FULL_LIBDIR}")
message(STATUS "  Headers   : ${FREEFEM_INSTALL_FULL_INCLUDEDIR}")
message(STATUS "  Plugins   : ${FREEFEM_INSTALL_FULL_PLUGINDIR}")
message(STATUS "  Idps      : ${FREEFEM_INSTALL_FULL_DATADIR}")
message(STATUS "  Config    : ${FREEFEM_INSTALL_FULL_CONFIGDIR}")

### INSTALL_RPATH settings
#
if(APPLE)
  set(base @loader_path)
else()
  set(base $ORIGIN)
endif()

file(RELATIVE_PATH lib_rel_dir
  ${PROJECT_BINARY_DIR}/${FREEFEM_INSTALL_BINDIR}
  ${PROJECT_BINARY_DIR}/${FREEFEM_INSTALL_LIBDIR}
)
file(RELATIVE_PATH plugins_rel_dir
  ${PROJECT_BINARY_DIR}/${FREEFEM_INSTALL_BINDIR}
  ${PROJECT_BINARY_DIR}/${FREEFEM_INSTALL_PLUGINDIR}
)
message(STATUS "${plugins_rel_dir}")
set(CMAKE_INSTALL_RPATH
  ${base}
  ${base}/${lib_rel_dir}
  ${base}/${plugins_rel_dir}
)
