set(TEST_DRIVER_FF ${CMAKE_SOURCE_DIR}/bin/test-driver-ff)

# Timeout for sequential tests
set(SEQ_TESTS_TIMEOUT 60)

add_subdirectory(3d)
add_subdirectory(3dSurf)
add_subdirectory(3dCurve)
add_subdirectory(misc)
add_subdirectory(eigen)
add_subdirectory(plugin)


