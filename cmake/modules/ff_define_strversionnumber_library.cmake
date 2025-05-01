macro(ff_define_strversionnumber_library)

  include(ff_create_strversionnumber)
  ff_create_strversionnumber()
  
  add_library(strversionnumber
    STATIC
    ${CMAKE_BINARY_DIR}/strversionnumber.cpp
  )
  
  target_include_directories(strversionnumber
    PRIVATE
    ${CMAKE_SOURCE_DIR}/src/fflib
    ${CMAKE_BINARY_DIR}
  )
  
  target_compile_definitions(strversionnumber PRIVATE VersionFreeFem=${FREEFEM_VERSION})

endmacro()
