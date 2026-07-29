set(TESTS_NAME
  buildParametricMeshL.edp
  LaplacianCurve.edp
  extractMeshes.edp
  elasticstring.edp
  tutomesh1d.edp
  basicGlue.edp
  WaveEquation-new1d.edp
  periodicL.edp
  border.edp Connectivite-L.edp
  LapDG2-1d.edp)

if(TARGET ARPACK::ARPACK)
  list(APPEND TESTS_NAME QMoscillator-new1d.edp)
endif()

foreach(TEST ${TESTS_NAME})
  add_test(NAME 3dCurve/${TEST}
    COMMAND $<TARGET_FILE:${FF_EXE_NAME}> -nw ${CMAKE_SOURCE_DIR}/examples/3dCurve/${TEST}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/examples/3dCurve)
  set_tests_properties(3dCurve/${TEST}
    PROPERTIES
    TIMEOUT ${SEQ_TESTS_TIMEOUT}
    ENVIRONMENT "FF_INCLUDEPATH=../../idp;FF_LOADPATH=${PROJECT_BINARY_DIR}/plugin/seq"
    LABELS "3dCurve")
endforeach()
