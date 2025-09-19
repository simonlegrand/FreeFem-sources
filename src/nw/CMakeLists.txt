add_executable(${FF_EXE_NW_NAME}
WIN32 MACOSX_BUNDLE)

target_sources(${FF_EXE_NW_NAME}
  PRIVATE
  ../Graphics/sansrgraph.cpp 
  ../mpi/parallelempi-empty.cpp 
  ../fflib/ffapi.cpp
  ../fflib/compositeFESpace.cpp
)

target_include_directories(${FF_EXE_NW_NAME}
  PRIVATE
  ../lglib 
  ../fflib
  ../femlib
  ../Graphics
  ${PROJECT_BINARY_DIR}
)

target_link_libraries(${FF_EXE_NW_NAME}
  PUBLIC
  ${FF_LIBLG_NAME}
  ${FF_LIBFF_NAME}
  PRIVATE
  BLAS::BLAS
)

set_target_properties(
  ${FF_EXE_NW_NAME}
  PROPERTIES
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED ON	
  ENABLE_EXPORTS 1
  BUILD_RPATH ${PROJECT_BINARY_DIR}/../../plugin/seq)

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

