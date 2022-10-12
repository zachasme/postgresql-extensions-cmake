# Build and install extension
add_library(foobar MODULE foobar.c)
target_link_libraries(foobar PostgreSQL::PostgreSQL)
set_target_properties(foobar PROPERTIES PREFIX "")
install(TARGETS foobar
  LIBRARY DESTINATION ${PostgreSQL_PKG_LIBRARY_DIR}
)

# Inject version number into .control file
configure_file(foobar.control foobar.control)
install(
  FILES
    ${CMAKE_CURRENT_BINARY_DIR}/foobar.control
    foobar--1.0.0.sql
  DESTINATION "${PostgreSQL_SHARE_DIR}/extension"
)

# Test extension
find_program(PG_REGRESS pg_regress
  HINTS
    "${PostgreSQL_PKG_LIBRARY_DIR}/pgxs/src/test/regress/"
    "${PostgreSQL_BIN_DIR}"
  REQUIRED)

add_test(
  NAME pg_regress
  COMMAND ${PG_REGRESS}
    --temp-instance=${CMAKE_BINARY_DIR}/tmp
    --bindir=${PostgreSQL_BIN_DIR}
    --inputdir=${CMAKE_CURRENT_SOURCE_DIR}
    --outputdir=${CMAKE_CURRENT_BINARY_DIR}
    --load-extension foobar
    test1
)
