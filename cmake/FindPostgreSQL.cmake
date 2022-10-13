set(CMAKE_MODULE_PATH_OLD ${CMAKE_MODULE_PATH})
set(CMAKE_MODULE_PATH "${CMAKE_ROOT}/Modules")
find_package(PostgreSQL)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH_OLD})

# We ran original:
# https://github.com/Kitware/CMake/blob/master/Modules/FindPostgreSQL.cmake
#
# Let's fix this for extension work and try to upstream it later
# ----------------------------------------------------------------------------

foreach(suffix ${PostgreSQL_KNOWN_VERSIONS})
  if(WIN32)
    list(APPEND PostgreSQL_PG_CONFIG_ADDITIONAL_SEARCH_SUFFIXES
        "$ENV{ProgramFiles}/PostgreSQL/${suffix}/bin"
        "$ENV{SystemDrive}/PostgreSQL/${suffix}/bin")
  endif()
  if(UNIX)
    list(APPEND PostgreSQL_PG_CONFIG_ADDITIONAL_SEARCH_SUFFIXES
        "/usr/lib/postgresql/${suffix}/bin")
  endif()
endforeach()

# try to find version specific first
find_program(_PG_CONFIG pg_config NO_DEFAULT_PATH PATHS ${PostgreSQL_PG_CONFIG_ADDITIONAL_SEARCH_SUFFIXES})
# fallback to system-wide
find_program(_PG_CONFIG pg_config PATHS /usr/local/pgsql/bin)

execute_process(COMMAND ${_PG_CONFIG} --bindir            OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE PostgreSQL_BIN_DIR)
execute_process(COMMAND ${_PG_CONFIG} --pkglibdir         OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE PostgreSQL_PKG_LIBRARY_DIR)
execute_process(COMMAND ${_PG_CONFIG} --sharedir          OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE PostgreSQL_SHARE_DIR)
execute_process(COMMAND ${_PG_CONFIG} --includedir-server OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE PostgreSQL_INCLUDE_DIRECTORY_SERVER)

# Fix Windows include directories
if(WIN32)
  list(APPEND PostgreSQL_INCLUDE_DIRS ${PostgreSQL_INCLUDE_DIRECTORY_SERVER}/port/win32)
  if(MSVC)
    list(APPEND PostgreSQL_INCLUDE_DIRS ${PostgreSQL_INCLUDE_DIRECTORY_SERVER}/port/win32_msvc)
  endif(MSVC)
endif(WIN32)
set_target_properties(PostgreSQL::PostgreSQL PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${PostgreSQL_INCLUDE_DIRS}")

# Add pg_regress binary
find_program(PostgreSQL_REGRESS pg_regress
  HINTS
    "${PostgreSQL_PKG_LIBRARY_DIR}/pgxs/src/test/regress/"
    "${PostgreSQL_BIN_DIR}"
)

# Helper command to add extensions
function(PostgreSQL_add_extension NAME)
  set(options RELOCATABLE)
  set(oneValueArgs COMMENT)
  set(multiValueArgs SOURCES DATA)
  cmake_parse_arguments(EXTENSION "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN} )

  # Add extension as a dynamically linked library
  add_library(${NAME} SHARED ${EXTENSION_SOURCES})
  # Link extension to PostgreSQL
  target_link_libraries(${NAME} PostgreSQL::PostgreSQL)
  # Avoid lib* prefix on output file
  set_target_properties(${NAME} PROPERTIES PREFIX "")

  # Generate .control file
  configure_file(
    ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/FindPostgreSQL/control.in
    ${NAME}.control
  )

  # Install .so/.dll to pkglib-dir
  install(TARGETS ${NAME} LIBRARY DESTINATION ${PostgreSQL_PKG_LIBRARY_DIR})
  # Install everything else into share-dir
  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.control
      ${EXTENSION_DATA}
    DESTINATION "${PostgreSQL_SHARE_DIR}/extension"
  )
endfunction()
