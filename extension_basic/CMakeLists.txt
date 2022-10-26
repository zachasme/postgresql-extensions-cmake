PostgreSQL_add_extension(basic
  RELOCATABLE
  COMMENT "A basic PostgreSQL extension"
  SOURCES
    basic.c
  INSTALLS
    basic--1.0.0.sql
  UPDATES
    basic--1.0.0--2.0.0.sql
)

# Test your extension
if(BUILD_TESTING)
  if(PostgreSQL_REGRESS)
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

  if(PostgreSQL_VALIDATE_EXTUPGRADE)
    add_test(
      NAME basic_validate_extupgrade
      COMMAND ${PostgreSQL_VALIDATE_EXTUPGRADE}
        --extname basic
        --from 1.0.0
        --to 2.0.0
    )
  endif()
endif()
