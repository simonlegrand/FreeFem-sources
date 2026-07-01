# Windows convention: flat layout under a single directory.
# DLLs and plugins live next to the FreeFEM executable.
#
#  <prefix>/
#  ├── bin/              FreeFEM++.exe, libff.dll, plugins/*.dll
#  ├── lib/              libff.lib  (import library)
#  ├── include/freefem/
#  ├── data/             idps
#  └── config/           freefem++.pref

set(FREEFEM_INSTALL_BINDIR     "${CMAKE_INSTALL_BINDIR}"
    CACHE PATH "Executables/DLLs install directory")
set(FREEFEM_INSTALL_LIBDIR     "${CMAKE_INSTALL_LIBDIR}"
    CACHE PATH "Libraries install directory")
set(FREEFEM_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_INCLUDEDIR}/freefem"
    CACHE PATH "C++ headers install directory")
set(FREEFEM_INSTALL_PLUGINDIR  "${CMAKE_INSTALL_BINDIR}"
    CACHE PATH "Plugins install directory")
set(FREEFEM_INSTALL_DATADIR    "${CMAKE_INSTALL_DATADIR}/freefem"
    CACHE PATH "Arch-independent data install directory (idps, examples)")
set(FREEFEM_INSTALL_CONFIGDIR  "${CMAKE_INSTALL_SYSCONFDIR}/freefem"
    CACHE PATH "Configuration install directory")
