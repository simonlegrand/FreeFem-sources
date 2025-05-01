add_library(libMesh)

# Don't add the 'lib' prefix to the library name.
set_target_properties(libMesh PROPERTIES
  PREFIX "")

target_sources(libMesh
  PRIVATE
  chrono.c
  eigenv.c
  libmeshb7.c
  memory.c)

target_include_directories(libMesh
  PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
)
