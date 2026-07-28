#[=======================================================================[.rst:
FindMMG
-------

Find the MMG mesh-adaptation library (https://www.mmgtools.org).

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``MMG::mmg``
  The umbrella mmg library (links mmg2d, mmg3d, mmgs).
``MMG::mmg2d``
  The 2D library.
``MMG::mmg3d``
  The 3D library.
``MMG::mmgs``
  The surface library.

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``MMG_FOUND``
  True if the system has the MMG library.
``MMG_VERSION``
  The version of the MMG library which was found.
``MMG_INCLUDE_DIRS``
  Include directories needed to use MMG.
``MMG_LIBRARIES``
  Libraries needed to link to MMG.

For each component ``<comp>`` (mmg, mmg2d, mmg3d, mmgs):

``MMG_<comp>_FOUND``
  True if that component was found.
``MMG_<comp>_LIBRARY``
  Path to the library for that component.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``MMG_INCLUDE_DIR``
  The directory containing ``mmg/libmmg.h``.
``MMG_<comp>_LIBRARY``
  The path to the library for component <comp>.

Hints
^^^^^

``MMG_ROOT``, ``MMG_DIR``
  Preferred installation prefix or directories to search.

#]=======================================================================]

include(FindPackageHandleStandardArgs)

# --------------------------------------------------------------------------
# Determine which components to look for.  Default: all of them.
# --------------------------------------------------------------------------
set(_MMG_ALL_COMPONENTS mmg mmg2d mmg3d mmgs)

if(NOT MMG_FIND_COMPONENTS)
  set(MMG_FIND_COMPONENTS ${_MMG_ALL_COMPONENTS})
endif()

# --------------------------------------------------------------------------
# Collect extra search paths from common environment / cache hints
# --------------------------------------------------------------------------
set(_MMG_SEARCH_PATHS "")
foreach(_hint MMG_ROOT MMG_DIR)
  if(DEFINED ${_hint})
    list(APPEND _MMG_SEARCH_PATHS "${${_hint}}")
  endif()
  if(DEFINED ENV{${_hint}})
    list(APPEND _MMG_SEARCH_PATHS "$ENV{${_hint}}")
  endif()
endforeach()

# --------------------------------------------------------------------------
# 1) Find the include directory
# --------------------------------------------------------------------------
find_path(MMG_INCLUDE_DIR
  NAMES mmg/libmmg.h          # umbrella header
  HINTS ${_MMG_SEARCH_PATHS}
  PATH_SUFFIXES include
)

# Fallback: if only a sub-library header is present (rare packaging)
if(NOT MMG_INCLUDE_DIR)
  find_path(MMG_INCLUDE_DIR
    NAMES mmg/mmg3d/libmmg3d.h
    HINTS ${_MMG_SEARCH_PATHS}
    PATH_SUFFIXES include
  )
endif()

# --------------------------------------------------------------------------
# 2) Extract version information from the header
# --------------------------------------------------------------------------
set(MMG_VERSION "")
if(MMG_INCLUDE_DIR)
  # MMG exposes MMG_VERSION_MAJOR / MINOR / PATCH in
  # <mmg/libmmgtypes.h>  (or <mmg/common/libmmgtypes.h> in older layouts).
  foreach(_vtypes_candidate
      "${MMG_INCLUDE_DIR}/mmg/libmmgtypes.h"
      "${MMG_INCLUDE_DIR}/mmg/common/libmmgtypes.h"
      "${MMG_INCLUDE_DIR}/mmg/mmg3d/libmmg3d.h")
    if(EXISTS "${_vtypes_candidate}")
      set(_MMG_VERSION_HEADER "${_vtypes_candidate}")
      break()
    endif()
  endforeach()

  if(_MMG_VERSION_HEADER)
    file(STRINGS "${_MMG_VERSION_HEADER}" _ver_major_line
         REGEX "^#define[ \t]+MMG_VERSION_MAJOR[ \t]+[0-9]+")
    file(STRINGS "${_MMG_VERSION_HEADER}" _ver_minor_line
         REGEX "^#define[ \t]+MMG_VERSION_MINOR[ \t]+[0-9]+")
    file(STRINGS "${_MMG_VERSION_HEADER}" _ver_patch_line
         REGEX "^#define[ \t]+MMG_VERSION_PATCH[ \t]+[0-9]+")

    string(REGEX REPLACE ".*MAJOR[ \t]+([0-9]+).*" "\\1"
           MMG_VERSION_MAJOR "${_ver_major_line}")
    string(REGEX REPLACE ".*MINOR[ \t]+([0-9]+).*" "\\1"
           MMG_VERSION_MINOR "${_ver_minor_line}")
    string(REGEX REPLACE ".*PATCH[ \t]+([0-9]+).*" "\\1"
           MMG_VERSION_PATCH "${_ver_patch_line}")

    if(MMG_VERSION_MAJOR AND MMG_VERSION_MINOR AND MMG_VERSION_PATCH)
      set(MMG_VERSION
          "${MMG_VERSION_MAJOR}.${MMG_VERSION_MINOR}.${MMG_VERSION_PATCH}")
    elseif(MMG_VERSION_MAJOR AND MMG_VERSION_MINOR)
      set(MMG_VERSION "${MMG_VERSION_MAJOR}.${MMG_VERSION_MINOR}")
    endif()
  endif()
  unset(_MMG_VERSION_HEADER)
endif()

# --------------------------------------------------------------------------
# 3) Find each component library
# --------------------------------------------------------------------------
set(MMG_LIBRARIES "")

# MMG may depend on the math library
find_library(_MMG_MATH_LIBRARY m)

foreach(_comp IN LISTS MMG_FIND_COMPONENTS)
  find_library(MMG_${_comp}_LIBRARY
    NAMES ${_comp}
    HINTS ${_MMG_SEARCH_PATHS}
    PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
  )

  if(MMG_${_comp}_LIBRARY)
    set(MMG_${_comp}_FOUND TRUE)
    list(APPEND MMG_LIBRARIES "${MMG_${_comp}_LIBRARY}")
  else()
    set(MMG_${_comp}_FOUND FALSE)
  endif()

  mark_as_advanced(MMG_${_comp}_LIBRARY)
endforeach()

if(_MMG_MATH_LIBRARY)
  list(APPEND MMG_LIBRARIES "${_MMG_MATH_LIBRARY}")
endif()

# --------------------------------------------------------------------------
# 4) Standard validation
# --------------------------------------------------------------------------
find_package_handle_standard_args(MMG
  REQUIRED_VARS MMG_INCLUDE_DIR MMG_LIBRARIES
  VERSION_VAR   MMG_VERSION
  HANDLE_COMPONENTS
)

# --------------------------------------------------------------------------
# 5) Set output variables & create imported targets
# --------------------------------------------------------------------------
if(MMG_FOUND)
  set(MMG_INCLUDE_DIRS "${MMG_INCLUDE_DIR}")

  # ----- per-component imported targets -----
  foreach(_comp IN LISTS MMG_FIND_COMPONENTS)
    if(MMG_${_comp}_FOUND AND NOT TARGET MMG::${_comp})
      add_library(MMG::${_comp} UNKNOWN IMPORTED)
      set_target_properties(MMG::${_comp} PROPERTIES
        IMPORTED_LOCATION             "${MMG_${_comp}_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${MMG_INCLUDE_DIR}"
      )
      # Link the math library if found
      if(_MMG_MATH_LIBRARY)
        set_property(TARGET MMG::${_comp} APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES "${_MMG_MATH_LIBRARY}")
      endif()
    endif()
  endforeach()

  # ----- convenience umbrella target: MMG::MMG -----
  if(NOT TARGET MMG::MMG)
    add_library(MMG::MMG INTERFACE IMPORTED)
    set_target_properties(MMG::MMG PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${MMG_INCLUDE_DIR}"
    )
    foreach(_comp IN LISTS MMG_FIND_COMPONENTS)
      if(TARGET MMG::${_comp})
        set_property(TARGET MMG::MMG APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES MMG::${_comp})
      endif()
    endforeach()
  endif()
endif()

mark_as_advanced(MMG_INCLUDE_DIR _MMG_MATH_LIBRARY)
