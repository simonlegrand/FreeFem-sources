
# include(ff_define_ffglut_executable)
# include(ff_define_freefem_executable)
# include(ff_define_freefem_mpi_executable)

# # define the three executables:
# # - ffglut
# # - FreeFem++
# # - FreeFem++-mpi

# ff_define_ffglut_executable()
#ff_define_freefem_executable()
# ff_define_freefem_mpi_executable()


# add_subdirectory(bamg)
#add_subdirectory(bamglib)
if(TARGET GLUT::GLUT)
  add_subdirectory(libMesh)
endif()
#
add_subdirectory(fflib)
add_subdirectory(lglib)

add_subdirectory(nw)
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  add_subdirectory(bin-win32)
endif()
# add_subdirectory(medit)
if (NOT WITHOUT_MPI)
  add_subdirectory(mpi)
endif()
