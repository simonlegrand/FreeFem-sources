### For distribution on Apple without Xcode:
#
#if (NOT "${CMAKE_GENERATOR}" STREQUAL "Xcode")
  install(TARGETS
    ${FF_MD2EDP_EXE_NAME}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/FreeFem++-nw.app/Contents/MacOS)
  install(TARGETS
    ${FF_LIBS}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/FreeFem++-nw.app/Contents/Frameworks)
  install(TARGETS
    ${FF_PLUGINS_LIST}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/FreeFem++-nw.app/Contents/PlugIns)
  install(FILES
    ${FF_IDP_FILES}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/FreeFem++-nw.app/Contents/Resources/idp)
#endif ()
# Handle idp files and linux specificities

set(FREEFEM_INSTALL_BINDIR     "${CMAKE_INSTALL_PREFIX}/FreeFem++-nw.app/Contents/MacOS"
    CACHE PATH "Executables install directory")
set(FREEFEM_INSTALL_LIBDIR     "${CMAKE_INSTALL_PREFIX}/FreeFem++-nw.app/Contents/Frameworks"
    CACHE PATH "Libraries install directory")
set(FREEFEM_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}/freefem"
    CACHE PATH "C++ headers install directory")
set(FREEFEM_INSTALL_PLUGINDIR  "${CMAKE_INSTALL_LIBDIR}/freefem"
    CACHE PATH "Plugins install directory")
set(FREEFEM_INSTALL_DATADIR    "${CMAKE_INSTALL_DATADIR}/freefem"
    CACHE PATH "Arch-independent data install directory (idps, examples)")
set(FREEFEM_INSTALL_CONFIGDIR  "${CMAKE_INSTALL_SYSCONFDIR}/freefem"
    CACHE PATH "Configuration install directory")

