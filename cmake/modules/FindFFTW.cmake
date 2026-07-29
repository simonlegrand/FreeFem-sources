#[=======================================================================[.rst:
FindFFTW
--------

Find the FFTW3 library — Fastest Fourier Transform in the West
(https://www.fftw.org).

Components
^^^^^^^^^^

**Precision** (at least one should be requested):

``DOUBLE``
  Double precision (``libfftw3``).  *Default when no components are listed.*
``FLOAT``
  Single precision (``libfftw3f``).
``LONGDOUBLE``
  Long-double precision (``libfftw3l``).
``QUAD``
  Quad precision (``libfftw3q``, GCC ``__float128``).

**Threading** (per-precision; requires the matching precision component):

``DOUBLE_THREADS``, ``FLOAT_THREADS``, ``LONGDOUBLE_THREADS``
  POSIX threads (``pthreads``) planner support.
``DOUBLE_OPENMP``, ``FLOAT_OPENMP``, ``LONGDOUBLE_OPENMP``
  OpenMP planner support.

**Distributed memory** (per-precision):

``DOUBLE_MPI``, ``FLOAT_MPI``, ``LONGDOUBLE_MPI``
  MPI distributed-memory transforms.

Imported Targets
^^^^^^^^^^^^^^^^

One target per component (created only when the component is found):

``FFTW::Double``, ``FFTW::Float``, ``FFTW::LongDouble``, ``FFTW::Quad``
``FFTW::DoubleThreads``, ``FFTW::FloatThreads``, ``FFTW::LongDoubleThreads``
``FFTW::DoubleOpenMP``,  ``FFTW::FloatOpenMP``,  ``FFTW::LongDoubleOpenMP``
``FFTW::DoubleMPI``,     ``FFTW::FloatMPI``,     ``FFTW::LongDoubleMPI``
``FFTW::FFTW``
  Umbrella INTERFACE target linking every found component.

Threading / OpenMP / MPI targets automatically link the corresponding base
precision target and the system threading / OpenMP / MPI libraries.

Result Variables
^^^^^^^^^^^^^^^^

``FFTW_FOUND``
  True if the system has the FFTW library.
``FFTW_VERSION``
  The version string (e.g. ``3.3.10``).
``FFTW_INCLUDE_DIRS``
  Include directories needed to use FFTW.
``FFTW_LIBRARIES``
  All libraries for the requested (and found) components.
``FFTW_<comp>_FOUND``
  True if component ``<comp>`` was found.
``FFTW_<comp>_LIBRARY``
  Path to the library for component ``<comp>``.

Cache Variables
^^^^^^^^^^^^^^^

``FFTW_INCLUDE_DIR``
  Directory containing ``fftw3.h``.
``FFTW_<comp>_LIBRARY``
  Path to each component library.

Hints
^^^^^

``FFTW_ROOT``, ``FFTW_DIR``, ``FFTWDIR``, ``FFTW3_ROOT``

#]=======================================================================]

include(FindPackageHandleStandardArgs)

# ======================================================================
# 0)  pkg-config bootstrap (optional — seeds paths & fallback version)
# ======================================================================
find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
  pkg_check_modules(_FFTW3_PC QUIET fftw3)
endif()

# ======================================================================
# 1)  Gather search-path hints
# ======================================================================
set(_FFTW_SEARCH_PATHS "")
foreach(_hint FFTW_ROOT FFTW_DIR FFTWDIR FFTW3_ROOT FFTW3_DIR)
  if(DEFINED ${_hint})
    list(APPEND _FFTW_SEARCH_PATHS "${${_hint}}")
  endif()
  if(DEFINED ENV{${_hint}})
    list(APPEND _FFTW_SEARCH_PATHS "$ENV{${_hint}}")
  endif()
endforeach()
if(_FFTW3_PC_FOUND)
  list(APPEND _FFTW_SEARCH_PATHS ${_FFTW3_PC_PREFIX} ${_FFTW3_PC_LIBDIR})
endif()

# ======================================================================
# 2)  Component table
#     _fftw_define_component(<COMP> <libname> <target> <base> <deptype>)
#       deptype := NONE | THREADS | OPENMP | MPI
# ======================================================================
macro(_fftw_define_component _comp _libname _target _base _deptype)
  set(_FFTW_${_comp}_LIBNAME  "${_libname}")
  set(_FFTW_${_comp}_TARGET   "${_target}")
  set(_FFTW_${_comp}_BASE     "${_base}")
  set(_FFTW_${_comp}_DEPTYPE  "${_deptype}")
  list(APPEND _FFTW_KNOWN_COMPONENTS "${_comp}")
endmacro()

set(_FFTW_KNOWN_COMPONENTS "")

#                      COMPONENT              LIBNAME            TARGET                     BASE         DEP
_fftw_define_component(DOUBLE                 fftw3              FFTW::Double               ""           NONE)
_fftw_define_component(FLOAT                  fftw3f             FFTW::Float                ""           NONE)
_fftw_define_component(LONGDOUBLE             fftw3l             FFTW::LongDouble           ""           NONE)
_fftw_define_component(QUAD                   fftw3q             FFTW::Quad                 ""           NONE)

_fftw_define_component(DOUBLE_THREADS         fftw3_threads      FFTW::DoubleThreads        DOUBLE       THREADS)
_fftw_define_component(FLOAT_THREADS          fftw3f_threads     FFTW::FloatThreads         FLOAT        THREADS)
_fftw_define_component(LONGDOUBLE_THREADS     fftw3l_threads     FFTW::LongDoubleThreads    LONGDOUBLE   THREADS)

_fftw_define_component(DOUBLE_OPENMP          fftw3_omp          FFTW::DoubleOpenMP         DOUBLE       OPENMP)
_fftw_define_component(FLOAT_OPENMP           fftw3f_omp         FFTW::FloatOpenMP          FLOAT        OPENMP)
_fftw_define_component(LONGDOUBLE_OPENMP      fftw3l_omp         FFTW::LongDoubleOpenMP     LONGDOUBLE   OPENMP)

_fftw_define_component(DOUBLE_MPI             fftw3_mpi          FFTW::DoubleMPI            DOUBLE       MPI)
_fftw_define_component(FLOAT_MPI              fftw3f_mpi         FFTW::FloatMPI             FLOAT        MPI)
_fftw_define_component(LONGDOUBLE_MPI         fftw3l_mpi         FFTW::LongDoubleMPI        LONGDOUBLE   MPI)

# ======================================================================
# 3)  Resolve requested components + implicit base-precision deps
# ======================================================================
if(NOT FFTW_FIND_COMPONENTS)
  set(FFTW_FIND_COMPONENTS DOUBLE)
endif()

# Validate
foreach(_comp IN LISTS FFTW_FIND_COMPONENTS)
  if(NOT "${_comp}" IN_LIST _FFTW_KNOWN_COMPONENTS)
    message(FATAL_ERROR
      "FindFFTW: unknown component \"${_comp}\".\n"
      "  Valid components: ${_FFTW_KNOWN_COMPONENTS}")
  endif()
endforeach()

# Implicitly add base-precision components required by feature components
# so that the base library is always found and the target can be created.
set(_FFTW_ALL_TO_FIND ${FFTW_FIND_COMPONENTS})
foreach(_comp IN LISTS FFTW_FIND_COMPONENTS)
  set(_base "${_FFTW_${_comp}_BASE}")
  if(_base AND NOT "${_base}" IN_LIST _FFTW_ALL_TO_FIND)
    list(APPEND _FFTW_ALL_TO_FIND "${_base}")
  endif()
endforeach()
list(REMOVE_DUPLICATES _FFTW_ALL_TO_FIND)

# ======================================================================
# 4)  Find the include directory
# ======================================================================
find_path(FFTW_INCLUDE_DIR
  NAMES fftw3.h
  HINTS ${_FFTW_SEARCH_PATHS}
        ${_FFTW3_PC_INCLUDE_DIRS}
  PATH_SUFFIXES include include/fftw3
)

# ======================================================================
# 5)  Extract version from fftw3.h
#       #define FFTW_VERSION "3.3.10"
# ======================================================================
set(FFTW_VERSION "")
if(FFTW_INCLUDE_DIR AND EXISTS "${FFTW_INCLUDE_DIR}/fftw3.h")
  file(STRINGS "${FFTW_INCLUDE_DIR}/fftw3.h" _fftw_ver_line
       REGEX "^#define[ \t]+FFTW_VERSION[ \t]+\"[0-9]+\\.[0-9]+(\\.[0-9]+)?\"")
  if(_fftw_ver_line)
    string(REGEX REPLACE
      "^#define[ \t]+FFTW_VERSION[ \t]+\"([0-9]+\\.[0-9]+(\\.[0-9]+)?)\".*"
      "\\1" FFTW_VERSION "${_fftw_ver_line}")
  endif()
  unset(_fftw_ver_line)
endif()
# Fallback: pkg-config
if(NOT FFTW_VERSION AND _FFTW3_PC_VERSION)
  set(FFTW_VERSION "${_FFTW3_PC_VERSION}")
endif()

# ======================================================================
# 6)  Find component libraries & transitive dependencies
# ======================================================================
find_library(_FFTW_MATH_LIBRARY m)

# Track which transitive dep packages we have already searched for
set(_FFTW_NEED_THREADS FALSE)
set(_FFTW_NEED_OPENMP  FALSE)
set(_FFTW_NEED_MPI     FALSE)

set(FFTW_LIBRARIES "")

foreach(_comp IN LISTS _FFTW_ALL_TO_FIND)
  find_library(FFTW_${_comp}_LIBRARY
    NAMES "${_FFTW_${_comp}_LIBNAME}"
    HINTS ${_FFTW_SEARCH_PATHS}
          ${_FFTW3_PC_LIBDIR}
          ${_FFTW3_PC_LIBRARY_DIRS}
    PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
  )

  if(FFTW_${_comp}_LIBRARY)
    set(FFTW_${_comp}_FOUND TRUE)
    list(APPEND FFTW_LIBRARIES "${FFTW_${_comp}_LIBRARY}")
  else()
    set(FFTW_${_comp}_FOUND FALSE)
  endif()

  # Flag which transitive deps we will need
  if(_FFTW_${_comp}_DEPTYPE STREQUAL "THREADS")
    set(_FFTW_NEED_THREADS TRUE)
  elseif(_FFTW_${_comp}_DEPTYPE STREQUAL "OPENMP")
    set(_FFTW_NEED_OPENMP TRUE)
  elseif(_FFTW_${_comp}_DEPTYPE STREQUAL "MPI")
    set(_FFTW_NEED_MPI TRUE)
  endif()

  mark_as_advanced(FFTW_${_comp}_LIBRARY)
endforeach()

# Find transitive dependency packages once
if(_FFTW_NEED_THREADS)
  find_package(Threads QUIET)
endif()
if(_FFTW_NEED_OPENMP)
  find_package(OpenMP QUIET COMPONENTS C CXX)
endif()
if(_FFTW_NEED_MPI)
  find_package(MPI QUIET COMPONENTS C)
endif()

if(_FFTW_MATH_LIBRARY)
  list(APPEND FFTW_LIBRARIES "${_FFTW_MATH_LIBRARY}")
endif()

# ======================================================================
# 7)  Standard validation  (only user-requested components are checked)
# ======================================================================
find_package_handle_standard_args(FFTW
  REQUIRED_VARS FFTW_INCLUDE_DIR FFTW_LIBRARIES
  VERSION_VAR   FFTW_VERSION
  HANDLE_COMPONENTS                       # validates FFTW_<comp>_FOUND
)

# ======================================================================
# 8)  Create imported targets
# ======================================================================
if(FFTW_FOUND)
  set(FFTW_INCLUDE_DIRS "${FFTW_INCLUDE_DIR}")

  foreach(_comp IN LISTS _FFTW_ALL_TO_FIND)
    if(NOT FFTW_${_comp}_FOUND)
      continue()
    endif()

    set(_tgt "${_FFTW_${_comp}_TARGET}")
    if(TARGET "${_tgt}")
      continue()
    endif()

    add_library("${_tgt}" UNKNOWN IMPORTED)
    set_target_properties("${_tgt}" PROPERTIES
      IMPORTED_LOCATION             "${FFTW_${_comp}_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${FFTW_INCLUDE_DIR}"
    )

    # -- libm --
    if(_FFTW_MATH_LIBRARY)
      set_property(TARGET "${_tgt}" APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${_FFTW_MATH_LIBRARY}")
    endif()

    # -- base-precision dependency --
    set(_base "${_FFTW_${_comp}_BASE}")
    if(_base)
      set(_base_tgt "${_FFTW_${_base}_TARGET}")
      if(TARGET "${_base_tgt}")
        set_property(TARGET "${_tgt}" APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES "${_base_tgt}")
      elseif(FFTW_${_base}_LIBRARY)
        # base target not yet created (shouldn't happen, but be safe)
        set_property(TARGET "${_tgt}" APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES "${FFTW_${_base}_LIBRARY}")
      endif()
    endif()

    # -- feature transitive dependency --
    set(_dep "${_FFTW_${_comp}_DEPTYPE}")
    if(_dep STREQUAL "THREADS")
      if(TARGET Threads::Threads)
        set_property(TARGET "${_tgt}" APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES Threads::Threads)
      endif()
    elseif(_dep STREQUAL "OPENMP")
      if(TARGET OpenMP::OpenMP_CXX)
        set_property(TARGET "${_tgt}" APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES OpenMP::OpenMP_CXX)
      elseif(TARGET OpenMP::OpenMP_C)
        set_property(TARGET "${_tgt}" APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES OpenMP::OpenMP_C)
      endif()
    elseif(_dep STREQUAL "MPI")
      if(TARGET MPI::MPI_C)
        set_property(TARGET "${_tgt}" APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES MPI::MPI_C)
      endif()
    endif()
  endforeach()

  # -- umbrella target: FFTW::FFTW --
  if(NOT TARGET FFTW::FFTW)
    add_library(FFTW::FFTW INTERFACE IMPORTED)
    set_target_properties(FFTW::FFTW PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${FFTW_INCLUDE_DIR}"
    )
    foreach(_comp IN LISTS _FFTW_ALL_TO_FIND)
      set(_tgt "${_FFTW_${_comp}_TARGET}")
      if(TARGET "${_tgt}")
        set_property(TARGET FFTW::FFTW APPEND PROPERTY
          INTERFACE_LINK_LIBRARIES "${_tgt}")
      endif()
    endforeach()
  endif()
endif()

mark_as_advanced(FFTW_INCLUDE_DIR _FFTW_MATH_LIBRARY)

