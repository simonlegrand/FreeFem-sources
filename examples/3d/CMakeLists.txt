set(TESTS_NAME
  3d-leman.md
  ArrayFE-3d.edp
  beam-3d.md
  cone.md
  convect-3d.md
  cube-period.md
  EqPoisson.md
  extract-boundary3d.md
  first.md
  intlevelset3d.md
  Lac.md
  Laplace3d.md
  LaplaceRT-3d.md
  meditddm.edp
  NSI3d-carac.md
  NSI3d.edp
  p.edp
  periodic-3d.md
  Poisson.edp
  pyramide.md
  sphere2.md
  sphere6.md
  Stokes.md
  TruncLac.edp
  crack-3d.md
  periodic3.edp
  LapDG3d1.md
  LapDG3d.md
  Connectivity-3d.md
  Elasticity-simple-support-BC.md)

foreach(TEST ${TESTS_NAME})
  add_test(NAME ${TEST}
    COMMAND $<TARGET_FILE:${FF_EXE_NAME}> -nw ${CMAKE_SOURCE_DIR}/examples/3d/${TEST}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/examples/3d)
  set_tests_properties(${TEST}
    PROPERTIES
    TIMEOUT ${SEQ_TESTS_TIMEOUT}
    ENVIRONMENT "FF_INCLUDEPATH=../../idp;FF_LOADPATH=${PROJECT_BINARY_DIR}/plugin/seq"
    LABELS "3d")
endforeach()
