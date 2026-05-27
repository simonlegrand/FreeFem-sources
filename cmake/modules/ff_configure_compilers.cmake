set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBAMG_LONG_LONG")

if(CMAKE_BUILD_TYPE EQUAL "Debug")
  message(STATUS "Debug build type")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DCHECK_KN" )
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCHECK_KN" )

  # if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  #     set(CMAKE_C_FLAGS "${FF_C_FLAGS} -fno-inline -fexceptions" )
  #     set(CMAKE_CXX_FLAGS "${FF_CXX_FLAGS} -fno-inline -fexceptions" )

  # endif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

else()
  message(STATUS "Release build type")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DNCHECKPTR" )
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DNCHECKPTR" )
endif()

