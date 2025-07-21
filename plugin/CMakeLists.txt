set(PLUGINS_LIST "")
add_subdirectory(seq)
# add_subdirectory(mpi)
set(FF_PLUGINS_LIST ${PLUGINS_LIST} PARENT_SCOPE)
