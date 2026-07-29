#[=======================================================================[.rst:
FindARPACK
----------

Find the ARPACK / arpack-ng library for large-scale eigenvalue problems
(https://github.com/opencollab/arpack-ng).

Components
^^^^^^^^^^

``ARPACK`` (default)
  The serial ARPACK library.
``PARPACK``
  The parallel ARPACK library (requires MPI).

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``ARPACK::ARPACK``
  The serial ARPACK library.
``ARPACK::PARPACK``
  The parallel ARPACK library (only when the ``PARPACK`` component is
  requested and found).

Result Variables
^^^^^^^^^^^^^^^^

``ARPACK_FOUND``
  True if the system has the ARPACK library.
``ARPACK_VERSION``
  The version of the ARPACK library which was found.
``ARPACK_INCLUDE_DIRS``
  Include directories needed to use ARPACK.
``ARPACK_LIBRARIES``
  Libraries needed to link to ARPACK (serial).
``ARPACK_PARPACK_FOUND``
  True if the parallel component was found.
``ARPACK_PARPACK_LIBRARY``
  Path to the PARPACK library.

Cache Variables
^^^^^^^^^^^^^^^

``ARPACK_INCLUDE_DIR``
  The directory containing ``arpackdef.h`` (arpack-ng) or the ARPACK headers.
``ARPACK_LIBRARY``
  The path to the serial ARPACK library.
``ARPACK_PARPACK_LIBRARY``
  The path to the parallel ARPACK library.

Hints
^^^^^

``ARPACK_ROOT``, ``ARPACK_DIR``
  Preferred installation prefix or directories to search.

#]=======================================================================]

include(FindPackageHandleStandardArgs)

# --------------------------------------------------------------------------
# 0) Try pkg-config first — it may provide flags, paths, and version
# --------------------------------------------------------------------------
find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
  pkg_check_modules(_ARPACK_PC QUIET arpack)
endif()

# --------------------------------------------------------------------------
# 1) Collect search paths
# --------------------------------------------------------------------------
set(_ARPACK_SEARCH_PATHS "")
foreach(_hint ARPACK_ROOT ARPACK_DIR)
  if(DEFINED ${_hint})
    list(APPEND _ARPACK_SEARCH_PATHS "${${_hint}}")
  endif()
  if(DEFINED ENV{${_hint}})
    list(APPEND _ARPACK_SEARCH_PATHS "$ENV{${_hint}}")
  endif()
endforeach()
# Append paths discovered by pkg-config, if any
if(_ARPACK_PC_FOUND)
  list(APPEND _ARPACK_SEARCH_PATHS ${_ARPACK_PC_PREFIX} ${_ARPACK_PC_LIBDIR})
endif()

# --------------------------------------------------------------------------
# 2) Determine requested components (default: serial only)
# --------------------------------------------------------------------------
set(_ARPACK_ALL_COMPONENTS ARPACK PARPACK)

if(NOT ARPACK_FIND_COMPONENTS)
  set(ARPACK_FIND_COMPONENTS ARPACK)
endif()

# --------------------------------------------------------------------------
# 3) Find the include directory
#    arpack-ng installs headers (arpackdef.h, arpack.h, arpack.hpp, …)
#    Legacy ARPACK (Fortran-only) may not ship headers at all.
# --------------------------------------------------------------------------
find_path(ARPACK_INCLUDE_DIR
  NAMES arpackdef.h
  HINTS ${_ARPACK_SEARCH_PATHS}
        ${_ARPACK_PC_INCLUDE_DIRS}
  PATH_SUFFIXES include include/arpack include/arpack-ng
)

# Fallback: the C++ interface header shipped by recent arpack-ng
if(NOT ARPACK_INCLUDE_DIR)
  find_path(ARPACK_INCLUDE_DIR
    NAMES arpack/arpackdef.h
    HINTS ${_ARPACK_SEARCH_PATHS}
          ${_ARPACK_PC_INCLUDE_DIRS}
    PATH_SUFFIXES include
  )
endif()

# --------------------------------------------------------------------------
# 4) Extract version from arpackdef.h  (arpack-ng >= 3.6)
# --------------------------------------------------------------------------
set(ARPACK_VERSION "")

if(ARPACK_INCLUDE_DIR)
  # The header may be directly in ARPACK_INCLUDE_DIR or in a sub-folder
  foreach(_candidate
      "${ARPACK_INCLUDE_DIR}/arpackdef.h"
      "${ARPACK_INCLUDE_DIR}/arpack/arpackdef.h")
    if(EXISTS "${_candidate}")
      set(_arpack_def_header "${_candidate}")
      break()
    endif()
  endforeach()

  if(_arpack_def_header)
    file(STRINGS "${_arpack_def_header}" _ver_major_line
         REGEX "^#define[ \t]+ARPACK_VERSION_MAJOR[ \t]+[0-9]+")
    file(STRINGS "${_arpack_def_header}" _ver_minor_line
         REGEX "^#define[ \t]+ARPACK_VERSION_MINOR[ \t]+[0-9]+")
    file(STRINGS "${_arpack_def_header}" _ver_patch_line
         REGEX "^#define[ \t]+ARPACK_VERSION_PATCH[ \t]+[0-9]+")

    if(_ver_major_line)
      string(REGEX REPLACE ".*MAJOR[ \t]+([0-9]+).*" "\\1"
             ARPACK_VERSION_MAJOR "${_ver_major_line}")
    endif()
    if(_ver_minor_line)
      string(REGEX REPLACE ".*MINOR[ \t]+([0-9]+).*" "\\1"
             ARPACK_VERSION_MINOR "${_ver_minor_line}")
    endif()
    if(_ver_patch_line)
      string(REGEX REPLACE ".*PATCH[ \t]+([0-9]+).*" "\\1"
             ARPACK_VERSION_PATCH "${_ver_patch_line}")
    endif()

    if(ARPACK_VERSION_MAJOR AND ARPACK_VERSION_MINOR AND ARPACK_VERSION_PATCH)
      set(ARPACK_VERSION
          "${ARPACK_VERSION_MAJOR}.${ARPACK_VERSION_MINOR}.${ARPACK_VERSION_PATCH}")
    elseif(ARPACK_VERSION_MAJOR AND ARPACK_VERSION_MINOR)
      set(ARPACK_VERSION
          "${ARPACK_VERSION_MAJOR}.${ARPACK_VERSION_MINOR}")
    endif()
  endif()
  unset(_arpack_def_header)
endif()

# Fallback: use version reported by pkg-config
if(NOT ARPACK_VERSION AND _ARPACK_PC_VERSION)
  set(ARPACK_VERSION "${_ARPACK_PC_VERSION}")
endif()

# --------------------------------------------------------------------------
# 5) Find the serial library
# --------------------------------------------------------------------------
find_library(ARPACK_LIBRARY
  NAMES arpack arpackng arpack_ng arpack-ng
  HINTS ${_ARPACK_SEARCH_PATHS}
        ${_ARPACK_PC_LIBDIR}
        ${_ARPACK_PC_LIBRARY_DIRS}
  PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
)

if(ARPACK_LIBRARY)
  set(ARPACK_ARPACK_FOUND TRUE)
else()
  set(ARPACK_ARPACK_FOUND FALSE)
endif()

# --------------------------------------------------------------------------
# 6) Find the parallel library (component PARPACK)
# --------------------------------------------------------------------------
if("PARPACK" IN_LIST ARPACK_FIND_COMPONENTS)
  find_library(ARPACK_PARPACK_LIBRARY
    NAMES parpack parpack_ng parpack-ng parpackng
    HINTS ${_ARPACK_SEARCH_PATHS}
    PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
  )

  if(ARPACK_PARPACK_LIBRARY)
    set(ARPACK_PARPACK_FOUND TRUE)
  else()
    set(ARPACK_PARPACK_FOUND FALSE)
  endif()

  mark_as_advanced(ARPACK_PARPACK_LIBRARY)
endif()

# --------------------------------------------------------------------------
# 7) Find transitive dependencies: LAPACK, BLAS (and MPI for PARPACK)
# --------------------------------------------------------------------------
# ARPACK is built on top of LAPACK/BLAS; we need them on the link line.
find_package(LAPACK QUIET)
find_package(BLAS   QUIET)

set(_ARPACK_DEP_LIBRARIES "")
if(LAPACK_FOUND)
  list(APPEND _ARPACK_DEP_LIBRARIES ${LAPACK_LIBRARIES})
elseif(BLAS_FOUND)
  list(APPEND _ARPACK_DEP_LIBRARIES ${BLAS_LIBRARIES})
endif()

# Math library (Fortran runtime may pull it, but be explicit)
find_library(_ARPACK_MATH_LIBRARY m)
if(_ARPACK_MATH_LIBRARY)
  list(APPEND _ARPACK_DEP_LIBRARIES "${_ARPACK_MATH_LIBRARY}")
endif()

if(ARPACK_PARPACK_FOUND)
  find_package(MPI QUIET COMPONENTS C Fortran)
endif()

# --------------------------------------------------------------------------
# 8) Assemble ARPACK_LIBRARIES
# --------------------------------------------------------------------------
set(ARPACK_LIBRARIES "")
if(ARPACK_LIBRARY)
  list(APPEND ARPACK_LIBRARIES "${ARPACK_LIBRARY}")
endif()
list(APPEND ARPACK_LIBRARIES ${_ARPACK_DEP_LIBRARIES})

# --------------------------------------------------------------------------
# 9) Standard validation
# --------------------------------------------------------------------------
# Note: ARPACK_INCLUDE_DIR is NOT required — legacy Fortran-only ARPACK
# may not install headers; only the library is mandatory.
find_package_handle_standard_args(ARPACK
  REQUIRED_VARS ARPACK_LIBRARY
  VERSION_VAR   ARPACK_VERSION
  HANDLE_COMPONENTS
)

# --------------------------------------------------------------------------
# 10) Create imported targets
# --------------------------------------------------------------------------
if(ARPACK_FOUND)
  # --- gather include dirs (may be empty for pure-Fortran installs) ---
  set(ARPACK_INCLUDE_DIRS "")
  if(ARPACK_INCLUDE_DIR)
    set(ARPACK_INCLUDE_DIRS "${ARPACK_INCLUDE_DIR}")
  endif()

  # --- ARPACK::ARPACK  (serial) ---
  if(ARPACK_ARPACK_FOUND AND NOT TARGET ARPACK::ARPACK)
    add_library(ARPACK::ARPACK UNKNOWN IMPORTED)
    set_target_properties(ARPACK::ARPACK PROPERTIES
      IMPORTED_LOCATION "${ARPACK_LIBRARY}"
    )
    if(ARPACK_INCLUDE_DIR)
      set_target_properties(ARPACK::ARPACK PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${ARPACK_INCLUDE_DIR}"
      )
    endif()
    # Transitive deps: LAPACK, BLAS, -lm
    if(LAPACK_FOUND AND TARGET LAPACK::LAPACK)
      set_property(TARGET ARPACK::ARPACK APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES LAPACK::LAPACK)
    elseif(LAPACK_FOUND)
      set_property(TARGET ARPACK::ARPACK APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES ${LAPACK_LIBRARIES})
    endif()
    if(BLAS_FOUND AND TARGET BLAS::BLAS)
      set_property(TARGET ARPACK::ARPACK APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES BLAS::BLAS)
    elseif(BLAS_FOUND)
      set_property(TARGET ARPACK::ARPACK APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES ${BLAS_LIBRARIES})
    endif()
    if(_ARPACK_MATH_LIBRARY)
      set_property(TARGET ARPACK::ARPACK APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${_ARPACK_MATH_LIBRARY}")
    endif()
  endif()

  # --- ARPACK::PARPACK (parallel) ---
  if(ARPACK_PARPACK_FOUND AND NOT TARGET ARPACK::PARPACK)
    add_library(ARPACK::PARPACK UNKNOWN IMPORTED)
    set_target_properties(ARPACK::PARPACK PROPERTIES
      IMPORTED_LOCATION "${ARPACK_PARPACK_LIBRARY}"
    )
    if(ARPACK_INCLUDE_DIR)
      set_target_properties(ARPACK::PARPACK PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${ARPACK_INCLUDE_DIR}"
      )
    endif()
    # PARPACK depends on serial ARPACK
    set_property(TARGET ARPACK::PARPACK APPEND PROPERTY
      INTERFACE_LINK_LIBRARIES ARPACK::ARPACK)
    # … and on MPI
    if(MPI_FOUND)
      if(TARGET MPI::MPI_Fortran)
        set_property(TARGET ARPACK::PARPACK APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES MPI::MPI_Fortran)
      elseif(TARGET MPI::MPI_C)
        set_property(TARGET ARPACK::PARPACK APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES MPI::MPI_C)
      elseif(MPI_LIBRARIES)
        set_property(TARGET ARPACK::PARPACK APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES ${MPI_LIBRARIES})
      endif()
    endif()
  endif()
endif()

mark_as_advanced(ARPACK_INCLUDE_DIR ARPACK_LIBRARY _ARPACK_MATH_LIBRARY)
