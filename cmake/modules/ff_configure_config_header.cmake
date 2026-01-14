# Some variables in the cmake.config.h.in are configured by other means, such as
# the call to configure_file.

function(ff_configure_config_header)

  # Check symbols
  include(CheckCXXSymbolExists)
  check_cxx_symbol_exists(erfc "cmath" HAVE_ERFC) # Uselss? Is in std lib
  check_cxx_symbol_exists(getenv "cstdlib" HAVE_GETENV)
  
  # Check headers
  include(CheckIncludeFiles)
  check_include_files(dlfcn.h HAVE_DLFCN_H)

  # Configure template config header and put in the build tree
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/config_cmake.h.in
    ${PROJECT_BINARY_DIR}/config.h)
  
endfunction()
