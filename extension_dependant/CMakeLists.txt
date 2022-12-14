PostgreSQL_add_extension(postgresql_dependant
  NAME dependant
  RELOCATABLE
  COMMENT "A PostgreSQL extension with dependencies"
  SOURCES
    dependant.c
  INSTALLS
    dependant--1.0.0.sql
)

target_include_directories(postgresql_dependant
  PRIVATE ${CMAKE_SOURCE_DIR}/include)

# link dependencies
add_subdirectory(dependencies)
target_link_libraries(postgresql_dependant h3)

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

  add_test(
    NAME dependant_inlined
    COMMAND sh -c "! objdump -D ${PostgreSQL_PKG_LIBRARY_DIR}/dependant.so | grep radsToDegs"
    CONFIGURATIONS Release
  )
endif()
