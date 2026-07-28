### Opportunistic detection pattern
#
# For each dependency dep:
# FF_WITH_${dep}:
# ON   : require <option> (fatal if not found)
# OFF  : never use <option>
# AUTO : use if available, no error if missing  (default)

set(ff_optional_deps
  OpenGL
  GLUT
  MPI
  GSL
  METIS
  TETGEN
  MMG
  # MSHMET
  arpackng
)

function(required_or_not _dep)
  # Default value, if not already set by a caller script
  if(NOT DEFINED FF_WITH_${_dep})
    set(FF_WITH_${_dep} "AUTO")
  endif()

  if(FF_WITH_${_dep} MATCHES "^(ON|TRUE|1)$")
    set(${_dep}_req REQUIRED PARENT_SCOPE)
  elseif(FF_WITH_${_dep} STREQUAL "AUTO")
    set(${_dep}_req QUIET PARENT_SCOPE)
  else()
    set(${_dep}_req "NO" PARENT_SCOPE)
  endif()
endfunction()

set(MPI_extra_args COMPONENTS CXX)

foreach(dep ${ff_optional_deps})
  required_or_not(${dep})
  if(NOT ${dep}_req STREQUAL "NO")
    find_package(${dep} ${${dep}_req} ${${dep}_extra_args})
  endif()
endforeach()

# Afficher un récap de ce qui a été trouvé
message(STATUS "[FreeFEM] Optional dependencies:")
foreach(dep ${ff_optional_deps})
  if (${dep}_FOUND)
    message(STATUS "  ${dep} : FOUND")
  else()
    message(STATUS "  ${dep} : NOT FOUND")
  endif()
endforeach()

# Extra definitions, for retrocompatibility with autotools version
#
if(arpackng_FOUND)
  set(HAVE_LIBARPACK ON)
endif()
