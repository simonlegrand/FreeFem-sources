set(TESTS_NAME
  aaa-adp.edp
  aadaptation.edp
  aalapacien.edp
  aalaplace-nc.edp
  aamove.edp
  aaRT.edp
  arrayoFVh.edp
  bilap.edp
  ccc-adp.edp
  D2.edp
  demo.edp
  demo1.edp
  FE-medit.edp
  funct.edp
  include.edp
  lap_mat.edp
  lapacienprecon.edp
  NSP1P1.edp
  NSP1P1b.edp
  NSP1P1bl.edp
  NSP1P2.edp
  parareal.edp
  renumbering.edp
  Richard.edp
  Stokes-P1nc-P0+P1.edp
  testadp.edp
  teste.edp
  testFE.edp
  wafer-heating-laser-axi.edp
  torture-search2d.edp
  lap3-cpu.edp
  bug-macro-on-win32.edp
)

foreach(TEST ${TESTS_NAME})
  add_test(NAME ${TEST}
    COMMAND $<TARGET_FILE:${FF_EXE_NAME}> -nw ${CMAKE_SOURCE_DIR}/examples/misc/${TEST}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/examples/misc)
  set_tests_properties(${TEST}
    PROPERTIES
    TIMEOUT ${SEQ_TESTS_TIMEOUT}
    ENVIRONMENT "FF_INCLUDEPATH=../../idp;FF_LOADPATH=${PROJECT_BINARY_DIR}/plugin/seq"
    LABELS "misc"
  )
endforeach()
