set(TESTS_NAME
  buildMeshSfromMesh3.edp
  glu3DSurf.edp
  Laplace3dSP2.edp
  LaplacianSurf.edp
  operatorsOnMeshS.edp
  extractSurfFromMesh3.edp
  testvtk.edp
  LapP1withflux.edp
  cauchyproblem.edp
  periodicS.edp
  Connectivite-S.edp
  LaplaceRT1Surf.edp
  buildmeshS.edp
)

if(TARGET TETGEN::TETGEN)
  list(APPEND TESTS_NAME HeatTorus.edp)
endif()

if(TARGET MMG::mmg)
  list(APPEND TESTS_NAME Pinocchio.edp)
endif()

# TODO
# Add other conditional tests

foreach(TEST ${TESTS_NAME})
  add_test(NAME ${TEST}
    COMMAND $<TARGET_FILE:${FF_EXE_NAME}> -nw ${CMAKE_SOURCE_DIR}/examples/3dSurf/${TEST}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/examples/3dSurf)
  set_tests_properties(${TEST}
    PROPERTIES
    TIMEOUT ${SEQ_TESTS_TIMEOUT}
    ENVIRONMENT "FF_INCLUDEPATH=../../idp;FF_LOADPATH=${PROJECT_BINARY_DIR}/plugin/seq"
    LABELS "3dSurf")
endforeach()
