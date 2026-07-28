#[=======================================================================[.rst:
FindMETIS
---------

Find the METIS graph-partitioning library (https://github.com/KarypisLab/METIS).

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported target, if found:

``METIS::METIS``
  The METIS library.

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``METIS_FOUND``
  True if the system has the METIS library.
``METIS_VERSION``
  The version of the METIS library which was found.
``METIS_INCLUDE_DIRS``
  Include directories needed to use METIS.
``METIS_LIBRARIES``
  Libraries needed to link to METIS.
``METIS_IDX_WIDTH``
  The width (in bits) of the ``idx_t`` integer type (32 or 64).
  Empty if it could not be determined.
``METIS_REAL_WIDTH``
  The width (in bits) of the ``real_t`` floating-point type (32 or 64).
  Empty if it could not be determined.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``METIS_INCLUDE_DIR``
  The directory containing ``metis.h``.
``METIS_LIBRARY``
  The path to the METIS library.

Hints
^^^^^

``METIS_ROOT``, ``METIS_DIR``
  Preferred installation prefix or directories to search.

#]=======================================================================]

include(FindPackageHandleStandardArgs)

# --------------------------------------------------------------------------
# Collect extra search paths from common environment / cache hints
# --------------------------------------------------------------------------
set(_METIS_SEARCH_PATHS "")
foreach(_hint METIS_ROOT METIS_DIR)
  if(DEFINED ${_hint})
    list(APPEND _METIS_SEARCH_PATHS "${${_hint}}")
  endif()
  if(DEFINED ENV{${_hint}})
    list(APPEND _METIS_SEARCH_PATHS "$ENV{${_hint}}")
  endif()
endforeach()

# --------------------------------------------------------------------------
# 1) Find the include directory
# --------------------------------------------------------------------------
find_path(METIS_INCLUDE_DIR
  NAMES metis.h
  HINTS ${_METIS_SEARCH_PATHS}
  PATH_SUFFIXES include include/metis
)

# --------------------------------------------------------------------------
# 2) Extract version and type-width information from metis.h
# --------------------------------------------------------------------------
set(METIS_VERSION "")
set(METIS_IDX_WIDTH "")
set(METIS_REAL_WIDTH "")

if(METIS_INCLUDE_DIR AND EXISTS "${METIS_INCLUDE_DIR}/metis.h")
  set(_metis_header "${METIS_INCLUDE_DIR}/metis.h")

  # --- version ---
  file(STRINGS "${_metis_header}" _ver_major_line
       REGEX "^#define[ \t]+METIS_VER_MAJOR[ \t]+[0-9]+")
  file(STRINGS "${_metis_header}" _ver_minor_line
       REGEX "^#define[ \t]+METIS_VER_MINOR[ \t]+[0-9]+")
  file(STRINGS "${_metis_header}" _ver_patch_line
       REGEX "^#define[ \t]+METIS_VER_SUBMINOR[ \t]+[0-9]+")

  if(_ver_major_line)
    string(REGEX REPLACE ".*MAJOR[ \t]+([0-9]+).*" "\\1"
           METIS_VERSION_MAJOR "${_ver_major_line}")
  endif()
  if(_ver_minor_line)
    string(REGEX REPLACE ".*MINOR[ \t]+([0-9]+).*" "\\1"
           METIS_VERSION_MINOR "${_ver_minor_line}")
  endif()
  if(_ver_patch_line)
    string(REGEX REPLACE ".*SUBMINOR[ \t]+([0-9]+).*" "\\1"
           METIS_VERSION_PATCH "${_ver_patch_line}")
  endif()

  if(METIS_VERSION_MAJOR AND METIS_VERSION_MINOR AND METIS_VERSION_PATCH)
    set(METIS_VERSION
        "${METIS_VERSION_MAJOR}.${METIS_VERSION_MINOR}.${METIS_VERSION_PATCH}")
  elseif(METIS_VERSION_MAJOR AND METIS_VERSION_MINOR)
    set(METIS_VERSION "${METIS_VERSION_MAJOR}.${METIS_VERSION_MINOR}")
  endif()

  # --- IDXTYPEWIDTH  (32 or 64 — controls sizeof(idx_t)) ---
  file(STRINGS "${_metis_header}" _idx_width_line
       REGEX "^#define[ \t]+IDXTYPEWIDTH[ \t]+[0-9]+")
  if(_idx_width_line)
    string(REGEX REPLACE ".*IDXTYPEWIDTH[ \t]+([0-9]+).*" "\\1"
           METIS_IDX_WIDTH "${_idx_width_line}")
  endif()

  # --- REALTYPEWIDTH (32 or 64 — controls sizeof(real_t)) ---
  file(STRINGS "${_metis_header}" _real_width_line
       REGEX "^#define[ \t]+REALTYPEWIDTH[ \t]+[0-9]+")
  if(_real_width_line)
    string(REGEX REPLACE ".*REALTYPEWIDTH[ \t]+([0-9]+).*" "\\1"
           METIS_REAL_WIDTH "${_real_width_line}")
  endif()

  unset(_metis_header)
endif()

# --------------------------------------------------------------------------
# 3) Find the library
# --------------------------------------------------------------------------
find_library(METIS_LIBRARY
  NAMES metis
  HINTS ${_METIS_SEARCH_PATHS}
  PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
)

# METIS may depend on the math library
find_library(_METIS_MATH_LIBRARY m)

# Assemble the full list
set(METIS_LIBRARIES "")
if(METIS_LIBRARY)
  list(APPEND METIS_LIBRARIES "${METIS_LIBRARY}")
endif()
if(_METIS_MATH_LIBRARY)
  list(APPEND METIS_LIBRARIES "${_METIS_MATH_LIBRARY}")
endif()

# --------------------------------------------------------------------------
# 4) Standard validation
# --------------------------------------------------------------------------
find_package_handle_standard_args(METIS
  REQUIRED_VARS METIS_LIBRARY METIS_INCLUDE_DIR
  VERSION_VAR   METIS_VERSION
)

# --------------------------------------------------------------------------
# 5) Set output variables & create imported target
# --------------------------------------------------------------------------
if(METIS_FOUND)
  set(METIS_INCLUDE_DIRS "${METIS_INCLUDE_DIR}")

  if(NOT TARGET METIS::METIS)
    add_library(METIS::METIS UNKNOWN IMPORTED)
    set_target_properties(METIS::METIS PROPERTIES
      IMPORTED_LOCATION             "${METIS_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${METIS_INCLUDE_DIR}"
    )
    if(_METIS_MATH_LIBRARY)
      set_property(TARGET METIS::METIS APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${_METIS_MATH_LIBRARY}")
    endif()
  endif()
endif()

mark_as_advanced(METIS_INCLUDE_DIR METIS_LIBRARY _METIS_MATH_LIBRARY)
