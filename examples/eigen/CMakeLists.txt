set(TESTS_NAME "")

if(TARGET ARPACK::ARPACK)
  list(APPEND TESTS_NAME
    BeamEigenValue.edp
    BeamEigenValueperio.edp
    condition-number.edp
    free-cyl-axi.edp
    Lap3dEigenValue.edp
    LapComplexEigenValue.edp
    LapEigenValue.edp
    LapEigenValueFunc.edp
    LapEigenValueFuncV2.edp
    LapnosymComplexEigenValue.edp
    LapnosymEigenValue.edp
    neuman.edp
    Stokes-eigen.edp
    VP-Steklov-Poincare.edp
    WGM-sphere.edp
    LapEigenBeltrami.edp
    LapEigenValueFuncComplex.edp)
endif()

foreach(TEST ${TESTS_NAME})
  add_test(NAME ${TEST}
    COMMAND $<TARGET_FILE:${FF_EXE_NAME}> -nw ${CMAKE_SOURCE_DIR}/examples/eigen/${TEST}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/examples/eigen)
  set_tests_properties(${TEST}
    PROPERTIES
    TIMEOUT ${SEQ_TESTS_TIMEOUT}
    ENVIRONMENT "FF_INCLUDEPATH=../../idp;FF_LOADPATH=${PROJECT_BINARY_DIR}/plugin/seq"
    LABELS "eigen")
endforeach()
