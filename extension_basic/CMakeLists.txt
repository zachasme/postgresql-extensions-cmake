project(
  basic
  VERSION ${CMAKE_PROJECT_VERSION}
)

PostgreSQL_add_extension(${PROJECT_NAME}
  RELOCATABLE
  COMMENT "A basic PostgreSQL extension"
  SOURCES
    basic.c
  DATA
    basic--1.0.0.sql
)

# Test your extension
if(BUILD_TESTING AND PostgreSQL_REGRESS)
  add_test(
    NAME basic_pg_regress
    COMMAND ${PostgreSQL_REGRESS}
      --temp-instance=${CMAKE_BINARY_DIR}/tmp
      --bindir=${PostgreSQL_BIN_DIR}
      --inputdir=${CMAKE_CURRENT_SOURCE_DIR}
      --outputdir=${CMAKE_CURRENT_BINARY_DIR}
      --load-extension basic
      test1
  )
endif()
