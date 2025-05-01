add_library(bamglib)

target_sources(bamglib
  PRIVATE
  Mesh2.cpp
  MeshDraw.cpp
  MeshGeom.cpp
  Meshgibbs.cpp
  Meshio.cpp
  MeshQuad.cpp
  MeshRead.cpp
  MeshWrite.cpp
  Metric.cpp
  QuadTree.cpp
  R2.cpp
  SetOfE4.cpp
  write_hdf5.cpp
  write_xdmf.cpp
)

target_include_directories(bamglib
  PRIVATE
  .
  ../fflib
)
