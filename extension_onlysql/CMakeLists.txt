PostgreSQL_add_extension(onlysql
  RELOCATABLE
  COMMENT "A PostgreSQL extension with dependencies"
  INSTALLS
    onlysql--1.0.0.sql
)

# Test your extension
if(BUILD_TESTING AND PostgreSQL_REGRESS)
  add_test(
    NAME onlysql_pg_regress
    COMMAND ${PostgreSQL_REGRESS}
      --temp-instance=${CMAKE_BINARY_DIR}/tmp
      --bindir=${PostgreSQL_BIN_DIR}
      --inputdir=${CMAKE_CURRENT_SOURCE_DIR}
      --outputdir=${CMAKE_CURRENT_BINARY_DIR}
      --load-extension onlysql
      test1
  )
endif()
