# To respect FHS recommandations
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    set(CMAKE_INSTALL_PREFIX "/opt/${PROJECT_NAME}")
  endif()
endif()

message(STATUS "CMAKE_INSTALL_FULL_SYSCONFDIR:${CMAKE_INSTALL_FULL_SYSCONFDIR}")
# Handle idp files and linux specificities
set(FREEFEM_INSTALL_BINDIR     "${CMAKE_INSTALL_BINDIR}"
    CACHE PATH "Executables install directory")
set(FREEFEM_INSTALL_LIBDIR     "${CMAKE_INSTALL_LIBDIR}"
    CACHE PATH "Libraries install directory")
set(FREEFEM_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}/freefem"
    CACHE PATH "C++ headers install directory")
set(FREEFEM_INSTALL_PLUGINDIR  "${CMAKE_INSTALL_LIBDIR}/freefem"
    CACHE PATH "Plugins install directory")
set(FREEFEM_INSTALL_DATADIR    "${CMAKE_INSTALL_DATADIR}/freefem"
  CACHE PATH "Arch-independent data install directory (idps, examples)")
set(FREEFEM_INSTALL_CONFIGDIR  "${CMAKE_INSTALL_SYSCONFDIR}"
    CACHE PATH "Configuration install directory")
