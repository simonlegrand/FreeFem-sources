set(FF_EXE_NW_NAME FreeFem++-nw)

add_executable(${FF_EXE_NW_NAME})

target_sources(${FF_EXE_NW_NAME}
  PRIVATE
  ${CMAKE_SOURCE_DIR}/src/Graphics/sansrgraph.cpp 
  ${CMAKE_SOURCE_DIR}/src/mpi/parallelempi-empty.cpp 
  ${CMAKE_SOURCE_DIR}/src/fflib/ffapi.cpp
  ${CMAKE_SOURCE_DIR}/src/fflib/compositeFESpace.cpp
)

target_include_directories(${FF_EXE_NW_NAME}
  PRIVATE
  ${CMAKE_SOURCE_DIR}/src/lglib 
  ${CMAKE_SOURCE_DIR}/src/fflib
  ${CMAKE_SOURCE_DIR}/src/femlib
  ${CMAKE_SOURCE_DIR}/src/Graphics
  ${CMAKE_BINARY_DIR}
)

target_link_libraries(${FF_EXE_NW_NAME}
  PRIVATE
  lglib
  ff
)
