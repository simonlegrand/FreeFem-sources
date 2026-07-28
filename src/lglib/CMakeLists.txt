add_library(${FF_LIBLG_NAME} STATIC)

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

target_link_libraries(${FF_LIBLG_NAME}
  PRIVATE
  ${FF_CONFIG_H_LIB}
)

if(TARGET ARPACK::ARPACK)
  target_link_libraries(${FF_LIBLG_NAME}
    PRIVATE
    ARPACK::ARPACK
  )
endif()

set_target_properties(${FF_LIBLG_NAME}
  PROPERTIES
  PREFIX ""
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED ON
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
    $<TARGET_FILE_DIR:${FF_EXE_NAME}>/../Frameworks/$<TARGET_FILE_NAME:${FF_LIBLG_NAME}>)
endif()
