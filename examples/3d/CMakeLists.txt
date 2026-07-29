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

if(TARGET METIS::METIS)
  list(APPEND TESTS_NAME
    schwarz-nm-3d.md
  )
endif()

if(TARGET TETGEN::TETGEN)
  list(APPEND TESTS_NAME
    cylinder.edp
    cylinder-3d.md
    Poisson3d.md
    Poisson-cube-ballon.md
    refinesphere.md
    tetgencube.edp
    tetgenholeregion.md
  )
  if(TARGET MMG::mmg)
    list(APPEND TESTS_NAME
      Sphere-Isocahedron.md
      Period-Poisson-cube-ballon.md
      sphereincube.md
      adaptindicator3dP1.md
      fallingspheres.md
    )
  endif()
  if(TARGET GSL::gsl)
    list(APPEND TESTS_NAME
      bottle.md
    )
endif()
endif()

# Take longer than the default 60s timeout.
# It allows to skip those tests in CI with the ctest "-LE long" option.
set(NSI3d.edp_EXTRA_LABELS "long")
set(NSI3d-carac.md_EXTRA_LABELS "long")
set(periodic-3d.md_EXTRA_LABELS "long")

foreach(TEST ${TESTS_NAME})
  add_test(NAME 3d/${TEST}
    COMMAND $<TARGET_FILE:${FF_EXE_NAME}> -nw ${CMAKE_SOURCE_DIR}/examples/3d/${TEST}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/examples/3d)
  set_tests_properties(3d/${TEST}
    PROPERTIES
    TIMEOUT ${SEQ_TESTS_TIMEOUT}
    ENVIRONMENT "FF_INCLUDEPATH=../../idp;FF_LOADPATH=${PROJECT_BINARY_DIR}/plugin/seq"
    LABELS "3d;${${TEST}_EXTRA_LABELS}")
endforeach()
