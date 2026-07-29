set(SEQ_PLUGINS_LIST
  myfunction
  BernardiRaugel
  Morley
  funcTemplate
  addNewType
  qf11to25
  Element_P3
  Element_P4
  Element_P3dc
  Element_P4dc 
  Element_PkEdge
  msh3 
  splitmesh3
  splitmesh6 
  splitmesh4
  splitmesh12 
  ffrandom
  medit 
  mat_dervieux
  lgbmo
  mat_psi 
  ppm2rnm
  DxWriter 
  pcm2rnm
  ioply 
  iovtk
  gmsh
  MetricKuate 
  Element_P1dc1
  BinaryIO 
  isoline 
  VTK_writer_3d
  VTK_writer 
  splitedges
  Element_Mixte
  Element_Mixte3d 
  myfunction2 
  MetricPk
  FreeFemQA
  shell 
  BEC 
  bfstream
  ff-AiryBiry 
  exactpartition
  ClosePoints 
  Element_HCT
  Curvature
  Element_P1bl 
  Element_QF
  distance
  Element_P1ncdc 
  Element_P2bulle3 
  Element_P2pnc
  SaveHB
  IncompleteCholesky 
  Schur-Complement
  biofunc
  mat_edgeP1 
  geophysics
  CircumCenter
  MatD-VFP0 
  meshtools
  Helmholtz_FD
  Element_P3pnc 
  vortextools
  MatrixMarket
  Element_P3nc 
  plotPDF
  Element_P2pnc_3d
  Element_P3pnc_3d
)

# Extra source files needed by plugins
set(lgbmo_EXTRA_SOURCES bmo.cpp)
set(FreeFemQA_EXTRA_SOURCES GeometryQA.cpp)
set(ffnewuoa_EXTRA_SOURCES newuoa.f)
set(ff-cmaes_EXTRA_SOURCES cmaes.cpp)
set(ff-mmap-semaphore_EXTRA_SOURCES libff-mmap-semaphore.c)
set(pcm2rnm_EXTRA_SOURCES pcm.cpp)

# Extra dependencies needed by plugins
set(Element_Mixte_EXTRA_DEPS "BLAS::BLAS;LAPACK::LAPACK")
set(IncompleteCholesky_EXTRA_DEPS "BLAS::BLAS;LAPACK::LAPACK")

# Plugin depending on optional dependencies
if(TARGET TETGEN::TETGEN)
  list(APPEND SEQ_PLUGINS_LIST tetgen)
  set(tetgen_EXTRA_DEPS "TETGEN::TETGEN")
endif()

if(TARGET MMG::mmg)
  list(APPEND SEQ_PLUGINS_LIST mmg)
  set(mmg_EXTRA_DEPS "MMG::mmg")
endif()

if(TARGET FFTW::Double)
  list(APPEND SEQ_PLUGINS_LIST dfft)
  set(dfft_EXTRA_DEPS "FFTW::Double")
endif()

if(TARGET METIS::METIS)
  list(APPEND SEQ_PLUGINS_LIST metis)
  set(metis_EXTRA_DEPS "METIS::METIS")
endif()

if(TARGET GSL::GSL)
  list(APPEND SEQ_PLUGINS_LIST gsl)
  set(gsl_EXTRA_DEPS "GSL::GSL")
endif()
set(PLUGINS_LIST ${SEQ_PLUGINS_LIST} PARENT_SCOPE)

# This doesn't seem standard, this dylib extension should be reserved
# to shared libraries and not modules.
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(CMAKE_SHARED_MODULE_SUFFIX ".dylib")
endif()

foreach(plugin ${SEQ_PLUGINS_LIST})
  set(EXTRA_SOURCES ${${plugin}_EXTRA_SOURCES})
  set(EXTRA_DEPS ${${plugin}_EXTRA_DEPS})
  add_library(${plugin} MODULE ${plugin}.cpp ${EXTRA_SOURCES})

  target_include_directories(${plugin}
    PRIVATE
    ${CMAKE_SOURCE_DIR}/src/fflib
    ${CMAKE_SOURCE_DIR}/src/femlib
    ${CMAKE_SOURCE_DIR}/src/bamglib
    ${CMAKE_SOURCE_DIR}/src/Algo
    ${CMAKE_SOURCE_DIR}/src/Graphics
    ${CMAKE_SOURCE_DIR}/src/libMesh
    ${CMAKE_SOURCE_DIR}/src/medit
  )

  target_link_libraries(${plugin}
    PRIVATE
    ${FF_CONFIG_H_LIB}
    ${EXTRA_DEPS}
  )
  
  set_target_properties(${plugin}
    PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
    PREFIX "")

  if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    # target_link_options(${plugin}
    #   PRIVATE
    #   -Wl,--enable-auto-import
    # )
    target_link_libraries(${plugin}
      PRIVATE
      ${FF_LIBFF_NAME}_shared
    )
  endif()

  if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    target_link_options(${plugin}
      PRIVATE
      -undefined dynamic_lookup)
    # If using XCode, copy libs and plugins in the bundle of the binary dir.
    #
    add_custom_command(TARGET ${plugin} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
      $<TARGET_FILE:${plugin}>
      $<TARGET_FILE_DIR:${FF_EXE_NAME}>/../PlugIns/$<TARGET_FILE_NAME:${plugin}>)
  endif()
endforeach()

# FILE(GLOB CPPFILES *.cpp)
  


# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/netgen.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/mshmet.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/tetgen.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/buildlayer.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/mmg3d-v4.0.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/ff-Ipopt.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/aniso.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/ilut.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/iohdf5.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/PARDISO.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/Curvature.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/scotch.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/SuperLu.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/freeyams.cpp)
# LIST(REMOVE_ITEM CPPFILES ${CMAKE_CURRENT_SOURCE_DIR}/UMFPACK64.cpp)


# FOREACH(CPPFILE ${CPPFILES})
#   GET_FILENAME_COMPONENT(FILENAME ${CPPFILE} NAME_WE)
#   ADD_LIBRARY(${FILENAME} MODULE ${CPPFILE})
#   TARGET_LINK_LIBRARIES(${FILENAME} ${MPI_CXX_LIBRARIES})
#   INCLUDE_DIRECTORIES(${MPI_CXX_INCLUDE_PATH} 
#                       ${CMAKE_SOURCE_DIR}/src/bamglib
#                       ${CMAKE_SOURCE_DIR}/src/Graphics
#                       ${CMAKE_SOURCE_DIR}/src/femlib
#                       ${CMAKE_SOURCE_DIR}/src/fflib)
#   SET_TARGET_PROPERTIES(${FILENAME} PROPERTIES PREFIX "")
# ENDFOREACH(CPPFILE)
