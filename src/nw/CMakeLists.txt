add_executable(${FF_EXE_NAME}
WIN32)

target_sources(${FF_EXE_NAME}
  PRIVATE
  ../Graphics/sansrgraph.cpp 
  ../mpi/parallelempi-empty.cpp 
  ../fflib/ffapi.cpp
)

target_sources(${FF_EXE_NAME}
  PRIVATE
    FILE_SET ff_exe_nw_private_headers
    TYPE HEADERS
    BASE_DIRS
      ../femlib
      ../Graphics
)

target_link_libraries(${FF_EXE_NAME}
  PRIVATE
  ${FF_CONFIG_H_LIB}
  PRIVATE
  BLAS::BLAS
)

if (CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
  target_sources(${FF_EXE_NAME}
    PRIVATE
    ../lglib/mymain.cpp
  )
  
  target_link_libraries(${FF_EXE_NAME}
    PRIVATE
    ${FF_LIBFF_NAME}_shared
  )
else()
  target_link_libraries(${FF_EXE_NAME}
    PRIVATE
    ${FF_LIBLG_NAME}
    ${FF_LIBFF_NAME}
  )
endif()

set_target_properties(
  ${FF_EXE_NAME}
  PROPERTIES
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED ON	
  ENABLE_EXPORTS 1
)

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set_target_properties(
    ${FF_EXE_NAME}
    PROPERTIES
    INSTALL_RPATH "@executable_path/../Frameworks;@executable_path/../PlugIns"
    MACOSX_BUNDLE_INFO_PLIST ${PROJECT_SOURCE_DIR}/etc/FreeFem++.app/Contents/Info.plist)
  # When using Xcode, there is no installation, libs and plugins are copied in
  # the bundle into the build tree.
  if(CMAKE_GENERATOR STREQUAL "Xcode")
    set_target_properties(
    ${FF_EXE_NAME}
      PROPERTIES
      BUILD_RPATH "@executable_path/../Frameworks;@executable_path/../PlugIns")
  endif()
endif()

### FFGLUT
if(TARGET GLUT::GLUT AND TARGET OpenGL::GLU)
  add_executable(${FF_GLUT_EXE_NAME}
    WIN32)

  set_target_properties(${FF_GLUT_EXE_NAME}
    PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
  )

  target_sources(${FF_GLUT_EXE_NAME}
    PRIVATE
    ../femlib/Drawing.cpp
    ../femlib/fem.cpp
    ../fflib/ffapi.cpp
    ../femlib/FQuadTree.cpp
    ../femlib/GQuadTree.cpp
    ../femlib/Mesh1dn.cpp
    ../femlib/Mesh2dn.cpp
    ../femlib/Mesh3dn.cpp
    ../femlib/MeshSn.cpp
    ../femlib/MeshLn.cpp
    ../femlib/mshptg.cpp
    ../Graphics/ffglut.cpp
    ../Graphics/ffthreads.cpp
    ../Graphics/ffthreads.hpp
    ../Graphics/gggg.cpp
  )

  target_sources(${FF_GLUT_EXE_NAME}
  PRIVATE
    FILE_SET ff_glut_private_headers
    TYPE HEADERS
    BASE_DIRS
    ../fflib
    ../femlib
    ../Graphics
  )

  target_link_libraries(${FF_GLUT_EXE_NAME}
    PRIVATE
    ${FF_CONFIG_H_LIB}
    ${FF_LIBMESH_NAME}
    GLUT::GLUT
    OpenGL::GLU
  )
endif()
