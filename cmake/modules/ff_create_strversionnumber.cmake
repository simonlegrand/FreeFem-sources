function(ff_create_strversionnumber)

  if(NOT EXISTS "${PROJECT_BINARY_DIR}/strversionnumber.cpp")
    message(STATUS "Configuring version number")
    string(TIMESTAMP VersionFreeFemDate "%b %a %d - %H:%M:%S - %Y")  
    execute_process(
      COMMAND git --git-dir=${CMAKE_SOURCE_DIR}/.git describe --tags
      OUTPUT_VARIABLE GitVersion
    )
    if (NOT GitVersion)
      set(GitVersion "no git")
    endif()
    
    # Remove trailing newline
    string(STRIP ${GitVersion} GitVersion)
    string(STRIP ${VersionFreeFemDate} VersionFreeFemDate)

    # Configure the file. Similar to what configure_file would do, but can't
    # introduce CMake variables into the m4 template.
    file(READ
      ${CMAKE_SOURCE_DIR}/src/fflib/strversionnumber.m4
      STRVERSIONNUMBER_CONTENT)
    
    string(REPLACE
      VersionFreeFemDate ${VersionFreeFemDate}
      CONFIGURED_CONTENT_TMP "${STRVERSIONNUMBER_CONTENT}")
    
    string(REPLACE GitVersion ${GitVersion}
      CONFIGURED_CONTENT "${CONFIGURED_CONTENT_TMP}")
  
    file(WRITE ${PROJECT_BINARY_DIR}/strversionnumber.cpp "${CONFIGURED_CONTENT}")
  endif()

endfunction(ff_create_strversionnumber)
