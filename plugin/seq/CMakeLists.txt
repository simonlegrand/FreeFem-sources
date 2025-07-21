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


set(PLUGINS_LIST ${SEQ_PLUGINS_LIST} PARENT_SCOPE)

foreach(plugin ${SEQ_PLUGINS_LIST})
  add_library(${plugin} MODULE ${plugin}.cpp)

  target_include_directories(${plugin}
    PRIVATE
    ${CMAKE_SOURCE_DIR}/src/fflib
    ${CMAKE_SOURCE_DIR}/src/femlib
    ${CMAKE_SOURCE_DIR}/src/bamglib
    ${CMAKE_SOURCE_DIR}/src/Algo
    ${CMAKE_SOURCE_DIR}/src/Graphics
    ${CMAKE_SOURCE_DIR}/src/libMesh
    ${CMAKE_SOURCE_DIR}/src/medit
    ${CMAKE_BINARY_DIR})

  # Checker l'influence de -bundle
  if(APPLE)
  target_link_options(${plugin}
    PRIVATE
    -bundle -undefined dynamic_lookup)
  endif()
  
  set_target_properties(${plugin}
    PROPERTIES
    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
    PREFIX "")
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
