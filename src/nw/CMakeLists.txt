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

set_target_properties(
  ${FF_EXE_NW_NAME}
  PROPERTIES
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED ON	
  ENABLE_EXPORTS 1
  POSITION_INDEPENDENT_CODE 1
)

target_link_libraries(${FF_EXE_NW_NAME}
  PUBLIC
  lglib
  ff
  PRIVATE
  LAPACK::LAPACK
)
