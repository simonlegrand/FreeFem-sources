function(ff_configure_config_header)

  # Check functions
  include(CheckFunctionExists)
  check_function_exists(acosh HAVE_ACOSH)
  check_function_exists(asinh HAVE_ASINH)
  check_function_exists(atanh HAVE_ATANH)
  
  # Check headers
  include(CheckIncludeFiles)
  check_include_files(malloc.h HAVE_MALLOC_H)
  check_include_files(cblas.h HAVE_CBLAS_H)
  check_include_files(cstddef HAVEC_CSTDDEF)

  # Factorize with ff_create_strversionnumber
  string(TIMESTAMP FREEFEM_BUILD_DATE "%b %a %d - %H:%M:%S - %Y")  
  # Configure template config header
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/config_cmake.h.in
    ${CMAKE_BINARY_DIR}/config.h)
  
endfunction()
