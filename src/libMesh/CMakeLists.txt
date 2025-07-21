add_library(${FF_LIBMESH_NAME})

target_sources(${FF_LIBMESH_NAME}
  PRIVATE
  chrono.c
  eigenv.c
  libmeshb7.c
  memory.c)

target_include_directories(${FF_LIBMESH_NAME}
  PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
)

