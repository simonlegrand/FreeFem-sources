add_library(${FF_LIBLG_NAME})

target_sources(${FF_LIBLG_NAME}
  PRIVATE
  lg.tab.cpp
  mymain.cpp
)

target_sources(${FF_LIBLG_NAME}
  PRIVATE
    FILE_SET ff_liblg_private_headers
    TYPE HEADERS
    BASE_DIRS
      ../fflib
      ../femlib
      ../Graphics
    FILES
      ../fflib/InitFunct.hpp
      ../fflib/strversionnumber.hpp
      ../fflib/error.hpp
      ../fflib/environment.hpp
      ../fflib/lex.hpp
      ../fflib/lgfem.hpp
      ../fflib/AFunction.hpp
      ../femlib/RNM.hpp
      ../femlib/fem.hpp
      ../femlib/FESpace.hpp
      ../femlib/FESpacen.hpp
      ../femlib/MeshPoint.hpp
      ../Graphics/rgraph.hpp
  PUBLIC
    FILE_SET ff_liblg_pub_headers
    TYPE HEADERS
    FILES
      lg.tab.hpp
)
message(STATUS "${FF_LIBLG_NAME} links with ${FF_CONFIG_H_LIB}")
target_link_libraries(${FF_LIBLG_NAME}
  PRIVATE
  ${FF_CONFIG_H_LIB}
)
# target_include_directories(${FF_LIBLG_NAME}
#   PRIVATE
#   ${CMAKE_BINARY_DIR}
# )

set_target_properties(${FF_LIBLG_NAME}
  PROPERTIES
  PREFIX ""
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED ON
  BUILD_RPATH ${PROJECT_BINARY_DIR}/../../plugin/seq
)

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  # Adapt RPATH for MacoS since it isn't the default file hierarchy
  # in the bundle.
  set_target_properties(
    ${FF_LIBLG_NAME}
    PROPERTIES
    BUILD_RPATH "@loader_path/../PlugIns")
  
  target_link_options(${FF_LIBLG_NAME}
    PRIVATE
    -undefined dynamic_lookup)

  # If using XCode, copy libs and plugins in the bundle of the binary dir.
  #
  add_custom_command(TARGET ${FF_LIBLG_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    $<TARGET_FILE:${FF_LIBLG_NAME}>
    $<TARGET_FILE_DIR:${FF_EXE_NW_NAME}>/../Frameworks/$<TARGET_FILE_NAME:${FF_LIBLG_NAME}>)
endif()

# TODO: remove this line as soon as autoconf is removed (only here for config.h and config-wrapper.h)
# INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}) 

# FILE(GLOB_RECURSE CPPFILES *.cpp)

# ADD_LIBRARY(lglib ${CPPFILES})

# INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/src/bamglib
#                     ${CMAKE_SOURCE_DIR}/src/femlib
#                     ${CMAKE_SOURCE_DIR}/src/fflib
#                     ${CMAKE_SOURCE_DIR}/src/Graphics
#                     ${CMAKE_SOURCE_DIR}/src/lglib/)

# SET_TARGET_PROPERTIES(lglib PROPERTIES PREFIX "")

# IF(FF_ARPACK_FOUND)

#   TARGET_COMPILE_DEFINITIONS(lglib PRIVATE -DHAVE_LIBARPACK)

#   if(MINGW)
#     TARGET_LINK_LIBRARIES(lglib FREEFEM::ARPACK FREEFEM::LAPACK gfortran)
#   else()
#     TARGET_LINK_LIBRARIES(lglib FREEFEM::ARPACK)
#   endif()

# ENDIF()


