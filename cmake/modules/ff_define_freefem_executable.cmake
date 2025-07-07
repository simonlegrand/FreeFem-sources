macro(ff_define_freefem_executable)

  # FreeFEM executable
  # 1. define executable FreeFEM (add_executable)
  # 2. define paths to header files (include_directories -> defines X in 'gcc -I X')
  # 3. define associated libraries which are defined in other CMake scripts (target_link_libraries -> defines X in 'gcc -l X') 
  # 4. define what to do when running 'make install' (install)  

  add_executable(FreeFem++)
  target_sources(FreeFem++
    PRIVATE
    ${CMAKE_SOURCE_DIR}/src/Graphics/sansrgraph.cpp 
    ${CMAKE_SOURCE_DIR}/src/mpi/parallelempi-empty.cpp 
    ${CMAKE_SOURCE_DIR}/src/fflib/ffapi.cpp
    ${CMAKE_SOURCE_DIR}/src/fflib/compositeFESpace.cpp
  )

  target_include_directories(FreeFem++
    PRIVATE
    ${CMAKE_SOURCE_DIR}/src/lglib 
    ${CMAKE_SOURCE_DIR}/src/fflib 
    #${CMAKE_SOURCE_DIR}/src/Graphics
  )

endmacro()
