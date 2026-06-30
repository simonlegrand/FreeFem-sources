add_executable(${FF_EXE_NW_NAME}
WIN32 MACOSX_BUNDLE)

target_sources(${FF_EXE_NW_NAME}
  PRIVATE
  ../Graphics/sansrgraph.cpp 
  ../mpi/parallelempi-empty.cpp 
  ../fflib/ffapi.cpp
)

target_sources(${FF_EXE_NW_NAME}
  PRIVATE
    FILE_SET ff_exe_nw_private_headers
    TYPE HEADERS
    BASE_DIRS
      ../femlib
      ../Graphics
)

target_link_libraries(${FF_EXE_NW_NAME}
  PRIVATE
  ${FF_CONFIG_H_LIB}
  PRIVATE
  BLAS::BLAS
)

if (CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
  target_sources(${FF_EXE_NW_NAME}
    PRIVATE
    ../lglib/mymain.cpp
  )
  
  target_link_libraries(${FF_EXE_NW_NAME}
    PRIVATE
    ${FF_LIBFF_NAME}_shared
  )
else()
  target_link_libraries(${FF_EXE_NW_NAME}
    PRIVATE
    ${FF_LIBLG_NAME}
    ${FF_LIBFF_NAME}
  )
endif()

set_target_properties(
  ${FF_EXE_NW_NAME}
  PROPERTIES
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED ON	
  ENABLE_EXPORTS 1
  #BUILD_RPATH ${PROJECT_BINARY_DIR}/../../plugin/seq)
)

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set_target_properties(
    ${FF_EXE_NW_NAME}
    PROPERTIES
    INSTALL_RPATH "@executable_path/../Frameworks;@executable_path/../PlugIns"
    MACOSX_BUNDLE_INFO_PLIST ${PROJECT_SOURCE_DIR}/etc/FreeFem++.app/Contents/Info.plist)
  # When using Xcode, there is no installation, libs and plugins are copied in
  # the bundle into the build tree.
  if(CMAKE_GENERATOR STREQUAL "Xcode")
    set_target_properties(
    ${FF_EXE_NW_NAME}
      PROPERTIES
      BUILD_RPATH "@executable_path/../Frameworks;@executable_path/../PlugIns")
  endif()
endif()

