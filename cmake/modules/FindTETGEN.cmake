#[=======================================================================[.rst:
FindTETGEN
----------

Find the TetGen mesh generation library.

TetGen generates tetrahedral meshes from 3D polyhedral domains.
See: https://codeberg.org/TetGen/TetGen

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``TETGEN::TETGEN``
  The TetGen library. Automatically defines the ``TETLIBRARY`` preprocessor
  macro required to use TetGen as a library.

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``TETGEN_FOUND``
  True if the system has the TetGen library.
``TETGEN_INCLUDE_DIRS``
  Include directories needed to use TetGen.
``TETGEN_LIBRARIES``
  Libraries needed to link to TetGen.
``TETGEN_VERSION``
  The version of TetGen found (e.g. "1.6.0"), if detected.
``TETGEN_VERSION_MAJOR``
  Major version component.
``TETGEN_VERSION_MINOR``
  Minor version component.
``TETGEN_VERSION_PATCH``
  Patch version component.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``TETGEN_INCLUDE_DIR``
  The directory containing ``tetgen.h``.
``TETGEN_LIBRARY``
  The path to the TetGen library (e.g. ``libtet.a``).

Hints
^^^^^

The following variables can be set to guide the search:

``TETGEN_ROOT`` or ``ENV{TETGEN_ROOT}``
  Root directory of a TetGen installation.

#]=======================================================================]

# Use TETGEN_ROOT as a hint (CMake 3.12+ does this for find_path/find_library
# automatically via <PackageName>_ROOT, but we also support ENV).
set(_TETGEN_SEARCH_PATHS "")
if(TETGEN_ROOT)
  list(APPEND _TETGEN_SEARCH_PATHS "${TETGEN_ROOT}")
endif()
if(DEFINED ENV{TETGEN_ROOT})
  list(APPEND _TETGEN_SEARCH_PATHS "$ENV{TETGEN_ROOT}")
endif()

# --- Find the header ---
find_path(TETGEN_INCLUDE_DIR
  NAMES tetgen.h
  HINTS ${_TETGEN_SEARCH_PATHS}
  PATH_SUFFIXES
    include
    include/tetgen
    tetgen
)

# --- Find the library ---
# TetGen's default Makefile builds the library as "libtet.a".
# Some package managers or custom builds may name it "libtetgen".
find_library(TETGEN_LIBRARY
  NAMES tet tetgen
  HINTS ${_TETGEN_SEARCH_PATHS}
  PATH_SUFFIXES
    lib
    lib64
    lib/tetgen
)

# --- Extract version from tetgen.h ---
if(TETGEN_INCLUDE_DIR AND EXISTS "${TETGEN_INCLUDE_DIR}/tetgen.h")
  # TetGen defines a version string like:
  #   #define TETLIBRARY_VERSION "1.6.0"
  # or in older versions:
  #   // TetGen Version 1.5.1
  # We try multiple patterns.

  # Try TETLIBRARY_VERSION first (TetGen >= 1.6)
  file(STRINGS "${TETGEN_INCLUDE_DIR}/tetgen.h" _tetgen_version_line
    REGEX "#define[ \t]+TETLIBRARY_VERSION[ \t]+"
  )

  if(_tetgen_version_line)
    string(REGEX REPLACE
      ".*#define[ \t]+TETLIBRARY_VERSION[ \t]+\"([0-9]+\\.[0-9]+\\.?[0-9]*)\".*"
      "\\1"
      TETGEN_VERSION
      "${_tetgen_version_line}"
    )
  else()
    # Fallback: look for a comment or macro like "// Version 1.5.1" or
    # "// TetGen Version 1.5.0"
    file(STRINGS "${TETGEN_INCLUDE_DIR}/tetgen.h" _tetgen_version_line
      REGEX "Version [0-9]+\\.[0-9]+"
    )
    if(_tetgen_version_line)
      # Take the first matching line
      list(GET _tetgen_version_line 0 _tetgen_version_line)
      string(REGEX REPLACE
        ".*Version[ \t]+([0-9]+\\.[0-9]+\\.?[0-9]*).*"
        "\\1"
        TETGEN_VERSION
        "${_tetgen_version_line}"
      )
    endif()
  endif()

  # Parse major.minor.patch
  if(TETGEN_VERSION)
    string(REPLACE "." ";" _tetgen_version_parts "${TETGEN_VERSION}")
    list(LENGTH _tetgen_version_parts _tetgen_version_count)

    list(GET _tetgen_version_parts 0 TETGEN_VERSION_MAJOR)
    if(_tetgen_version_count GREATER 1)
      list(GET _tetgen_version_parts 1 TETGEN_VERSION_MINOR)
    else()
      set(TETGEN_VERSION_MINOR "0")
    endif()
    if(_tetgen_version_count GREATER 2)
      list(GET _tetgen_version_parts 2 TETGEN_VERSION_PATCH)
    else()
      set(TETGEN_VERSION_PATCH "0")
    endif()
  endif()

  unset(_tetgen_version_line)
  unset(_tetgen_version_parts)
  unset(_tetgen_version_count)
endif()

# --- Standard validation ---
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TETGEN
  REQUIRED_VARS
    TETGEN_LIBRARY
    TETGEN_INCLUDE_DIR
  VERSION_VAR
    TETGEN_VERSION
)

# --- Create result variables ---
if(TETGEN_FOUND)
  set(TETGEN_LIBRARIES    "${TETGEN_LIBRARY}")
  set(TETGEN_INCLUDE_DIRS "${TETGEN_INCLUDE_DIR}")

  # --- Create imported target ---
  if(NOT TARGET TETGEN::TETGEN)
    add_library(TETGEN::TETGEN UNKNOWN IMPORTED)
    set_target_properties(TETGEN::TETGEN PROPERTIES
      IMPORTED_LOCATION             "${TETGEN_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${TETGEN_INCLUDE_DIR}"
      # TETLIBRARY must be defined so TetGen's header exposes the
      # library API instead of the standalone-executable API.
      INTERFACE_COMPILE_DEFINITIONS "TETLIBRARY"
    )
  endif()
endif()

# --- Clean up ---
unset(_TETGEN_SEARCH_PATHS)

mark_as_advanced(
  TETGEN_INCLUDE_DIR
  TETGEN_LIBRARY
)
