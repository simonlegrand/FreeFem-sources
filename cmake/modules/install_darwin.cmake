### For distribution on Apple without Xcode:
#
if (NOT "${CMAKE_GENERATOR}" STREQUAL "Xcode")
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
endif ()

