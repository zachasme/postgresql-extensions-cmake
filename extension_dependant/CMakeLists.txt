project(
  dependant
  VERSION ${CMAKE_PROJECT_VERSION}
)

PostgreSQL_add_extension(${PROJECT_NAME}
  RELOCATABLE
  COMMENT "A PostgreSQL extension with dependencies"
  SOURCES
    dependant.c
  DATA
    dependant--1.0.0.sql
)
target_include_directories(${PROJECT_NAME}
  PRIVATE ${CMAKE_SOURCE_DIR}/include)

# Test your extension
if(BUILD_TESTING AND PostgreSQL_REGRESS)
  add_test(
    NAME dependant_pg_regress
    COMMAND ${PostgreSQL_REGRESS}
      --temp-instance=${CMAKE_BINARY_DIR}/tmp
      --bindir=${PostgreSQL_BIN_DIR}
      --inputdir=${CMAKE_CURRENT_SOURCE_DIR}
      --outputdir=${CMAKE_CURRENT_BINARY_DIR}
      --load-extension dependant
      test1
  )
endif()