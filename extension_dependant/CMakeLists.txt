project(
  dependant
  VERSION ${CMAKE_PROJECT_VERSION}
)

PostgreSQL_add_extension(${PROJECT_NAME}
  RELOCATABLE
  #COMMENT "A PostgreSQL extension with dependencies"
  SOURCES
    dependant.c
  DATA
    dependant--1.0.0.sql
)
