set(TESTS_NAME
  APk-AdaptEpsDeltaPk.edp
  APk-ExplicitPkTest.edp
  APk-FreeFemQA.edp
  APk-MetricPk.edp
  bfstream.edp
  bilapHCT.edp
  bilapMorley.edp
  bilapP3-hct-like.edp
  bmo.edp
  ClosePoints.edp
  cmaes-oven.edp
  cmaes-VarIneq.edp
  convect_dervieux.edp
  convectchacon-3d.edp
  convectchacon.edp
  cube.edp
  distance.edp
  distance2.edp
  distance3.edp
  Element_QF.edp
  funcTemplate.edp
  glumesh3D.edp
  IncompleteCholesky.edp
  isoline.edp
  lame-TD-NSS.edp
  lapack.edp
  LapDG3.edp
  LapDG4.edp
  LaplaceP2pnc.edp
  LaplaceP3-3d.edp
  LaplaceP3.edp
  LaplaceP4.edp
  LaplaceRT1.edp
  LaplaceRT13d.edp
  LaplaceRT2.edp
  layer.edp
  Leman-mesh.edp
  load.edp
  meditddm.edp
  MetricKuate.edp
  mat_edgeP1.edp
  myfunction2.edp
  myType.edp
  NS_P2BR_P0.edp
  plot-fb-P3.edp
  plot-fb-P3dc.edp
  plot-fb-P4.edp
  plot-fb-P4dc.edp
  plotfb.edp
  ppm2rnm.edp
  provadxw.edp
  ref.edp
  RT2-ff.edp
  SaveHB_sample_z.edp
  SaveHB_sample.edp
  shell.edp
  splitedges.edp
  splitmesh3.edp
  splitmesh6.edp
  Stokes-surface-tension-axi.edp
  test-ElementMixte.edp
  testdist.edp
  testFE-P1bl.edp
  testFE_P2BR.edp
  testFE-P2Bulle3.edp
  testFE-P2pnc.edp
  testFE-P3.edp
  testFE-P3dc.edp
  testFE-P3nc.edp
  testFE-P3pnc.edp
  testFE-P4.edp
  testFE-P4dc.edp
  testFE-PkEdge.edp
  testFEHCT.edp
  testFEMorley.edp
  testp1dcnc.edp
  iovtk.edp
  ConnectedComponents.edp
  cavityNewtonP3pnc.edp
  MatrixMarket.edp
  plotPDF-sample.edp
  Stokes-P2pnc3d.edp
  RT0dc.edp testFE-P1nc3d.edp
  test_GrundmannMoller.edp
  test_PKLagrange.edp
  convergence_PkLagrange3d.edp)

if(TARGET FFTW::Double)
  list(APPEND TESTS_NAME dfft.edp dfft-3d.edp)
endif()

# Take longer than the default 60s timeout.
# It allows to skip those tests in CI with the ctest "-LE long" option.
set(LaplaceP4.edp_EXTRA_LABELS "long")
set(Stokes-P2pnc3d.edp_EXTRA_LABELS "long")
set(convergence_PkLagrange3d.edp_EXTRA_LABELS "long")

foreach(TEST ${TESTS_NAME})
  add_test(NAME plugin/${TEST}
    COMMAND $<TARGET_FILE:${FF_EXE_NAME}> -nw ${CMAKE_SOURCE_DIR}/examples/plugin/${TEST}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/examples/plugin)
  set_tests_properties(plugin/${TEST}
    PROPERTIES
    TIMEOUT ${SEQ_TESTS_TIMEOUT}
    ENVIRONMENT "FF_INCLUDEPATH=../../idp;FF_LOADPATH=${PROJECT_BINARY_DIR}/plugin/seq"
    LABELS "plugin;${${TEST}_EXTRA_LABELS}")
endforeach()
