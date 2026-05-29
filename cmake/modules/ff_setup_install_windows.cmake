# cmake/ff_setup_install_windows.cmake
#
# Windows convention: flat layout under a single directory.
# DLLs and plugins live next to or near the .exe for PATH/loading reasons.
#
#  <prefix>/
#  ├── bin/              FreeFEM++-nw.exe, libff.dll, plugins/*.dll
#  ├── lib/              libff.lib  (import library)
#  ├── include/freefem/
#  ├── data/             idps
#  └── config/           freefem++.pref

set(FREEFEM_INSTALL_BINDIR     "bin"              CACHE PATH "")
set(FREEFEM_INSTALL_LIBDIR     "lib"              CACHE PATH "")
set(FREEFEM_INSTALL_INCLUDEDIR "include/freefem"  CACHE PATH "")
set(FREEFEM_INSTALL_PLUGINDIR  "bin/plugins"      CACHE PATH "")  # near .exe
set(FREEFEM_INSTALL_DATADIR    "data/freefem"     CACHE PATH "")
set(FREEFEM_INSTALL_CONFIGDIR  "config"           CACHE PATH "")
