add_executable(${FF_EXE_NW_NAME}
WIN32 MACOSX_BUNDLE)

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
  BUILD_RPATH ${CMAKE_CURRENT_BINARY_DIR}/../../plugin/seq
)

target_link_libraries(${FF_EXE_NW_NAME}
  PUBLIC
  ${FF_LIBLG_NAME}
  ${FF_LIBFF_NAME}
  PRIVATE
  BLAS::BLAS
)
