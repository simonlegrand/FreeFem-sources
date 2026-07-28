# On Windows, the executables link against the static lib AND dynamic lib, and
# plugins against dynamic lib (that contains extra symbols of lg.tab.cpp).
# Remark: On MacOS, the Xcode generator messes with object library. Instead of
# factorizing, we have two complete pieces of CMake code, one for Windows, one
# for the rest.
# Common object files used by both Windows static and dynamic libff. Avoid
# compiling two times same files.
set(libff_sources
  UMFPack_Solver.cpp
  AFunction.cpp
  AFunction2.cpp
  array_long.cpp
  array_real.cpp
  array_complex.cpp
  lex.cpp
  lgmesh.cpp
  lgmesh3.cpp
  CodeAlloc.cpp
  lgmat.cpp
  global.cpp
  problem.cpp
  mt19937ar.cpp
  InitFunct.cpp
  load.cpp
  lgfem.cpp
  environment.cpp
  string_def.cpp
  glumesh2D.cpp
  msh3.cpp
  P1IsoValue.cpp
  compositeFESpace.cpp
  ../bamglib/QuadTree.cpp
  ../bamglib/R2.cpp
  ../bamglib/Meshio.cpp
  ../bamglib/Mesh2.cpp
  ../bamglib/Metric.cpp
  ../bamglib/MeshDraw.cpp
  ../bamglib/MeshGeom.cpp
  ../bamglib/MeshQuad.cpp
  ../bamglib/SetOfE4.cpp
  ../bamglib/MeshRead.cpp
  ../bamglib/write_hdf5.cpp
  ../bamglib/write_xdmf.cpp
  ../bamglib/MeshWrite.cpp
  ../femlib/BamgFreeFem.cpp
  ../femlib/Drawing.cpp
  ../femlib/gibbs.cpp
  ../femlib/CheckPtr.cpp
  ../femlib/fem.cpp
  ../femlib/QuadratureFormular.cpp
  ../femlib/FESpace.cpp
  ../femlib/Element_RT.cpp
  ../femlib/mshptg.cpp
  ../femlib/FQuadTree.cpp
  ../femlib/Element_P2h.cpp
  ../femlib/FESpacen.cpp
  ../femlib/P012_1d.cpp
  ../femlib/P012_2d.cpp
  ../femlib/P012_3d.cpp
  ../femlib/P012_3dSurf.cpp
  ../femlib/P012_3dCurve.cpp
  ../femlib/Mesh1dn.cpp
  ../femlib/Mesh2dn.cpp
  ../femlib/Mesh3dn.cpp
  ../femlib/MeshSn.cpp
  ../femlib/MeshLn.cpp
  ../femlib/GQuadTree.cpp
  ../femlib/libmeshb7.c
  ../femlib/splitsimplex.cpp
  ../femlib/HashMatrix.cpp
  ../femlib/CG.cpp
  ../femlib/SparseLinearSolver.cpp
  ../Graphics/DefColor.cpp
  ../Algo/lgalgo.cpp
  ${PROJECT_BINARY_DIR}/strversionnumber.cpp
)

if(TARGET ARPACK::ARPACK)
  list(APPEND libff_sources
    ../Eigen/eigenvalue.cpp
  )
endif()

if (CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
  add_library(ff_objects OBJECT)
  target_sources(ff_objects
    PRIVATE
    ${libff_sources}
    PUBLIC
    FILE_SET ff_libff_public_headers
      TYPE HEADERS
      BASE_DIRS
        ../lglib
        ../bamglib
        ../femlib
        ../Graphics
        ./
  )

  set_target_properties(ff_objects
    PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
  )

  target_link_libraries(ff_objects
    PUBLIC
    ${FF_CONFIG_H_LIB}
  )
  
  add_library(${FF_LIBFF_NAME} STATIC
    $<TARGET_OBJECTS:ff_objects>
  )
  
  add_library(${FF_LIBFF_NAME}_shared SHARED)
  target_sources(${FF_LIBFF_NAME}_shared
    PRIVATE
    $<TARGET_OBJECTS:ff_objects>
    ../lglib/lg.tab.cpp
    PUBLIC
    FILE_SET ff_libff_public_headers
      TYPE HEADERS
      BASE_DIRS
        ../lglib
        ../bamglib
        ../femlib
        ../Graphics
        ./
  )

  set_target_properties(${FF_LIBFF_NAME}_shared
    PROPERTIES
    OUTPUT_NAME ${FF_LIBFF_NAME}
  )
  
  target_link_libraries(${FF_LIBFF_NAME}_shared
    PUBLIC
    ${FF_CONFIG_H_LIB}
  )
else()
  add_library(${FF_LIBFF_NAME})
  target_sources(${FF_LIBFF_NAME}
    PRIVATE
    ${libff_sources}
    PUBLIC
    FILE_SET ff_libff_public_headers
      TYPE HEADERS
      BASE_DIRS
        ../lglib
        ../bamglib
        ../femlib
        ../Graphics
        ./
  )

  set_target_properties(${FF_LIBFF_NAME}
    PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
  )

  target_link_libraries(${FF_LIBFF_NAME}
    PUBLIC
    ${FF_CONFIG_H_LIB}
  )
endif()

if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set_target_properties(
    ${FF_LIBFF_NAME}
    PROPERTIES
    BUILD_RPATH "@loader_path/../PlugIns")
  
  target_link_options(${FF_LIBFF_NAME}
    PRIVATE
    -undefined dynamic_lookup
  )
endif()
