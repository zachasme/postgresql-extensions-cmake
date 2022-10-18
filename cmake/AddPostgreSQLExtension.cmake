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
  cmake_parse_arguments(EXTENSION "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # Add extension as a dynamically linked library
  add_library(${NAME} MODULE ${EXTENSION_SOURCES})

  # Link extension to PostgreSQL
  target_link_libraries(${NAME} PostgreSQL::PostgreSQL)

  # fix apple missing symbols
  if(APPLE)
    set_target_properties(
      ${NAME}
      PROPERTIES LINK_FLAGS ${PostgreSQL_LDFLAGS}
    )
  endif()

  # Final touches on output file
  set_target_properties(${NAME} PROPERTIES
    INTERPROCEDURAL_OPTIMIZATION TRUE
    #C_VISIBILITY_PRESET hidden # <--- HOW TO GET THIS WORKING?
    PREFIX "" # Avoid lib* prefix on output file
  )

  # Generate .control file
  configure_file(
    ${CMAKE_SOURCE_DIR}/cmake/FindPostgreSQL/control.in
    ${NAME}.control
  )

  # Install .so/.dll to pkglib-dir
  install(TARGETS ${NAME} LIBRARY DESTINATION "${PostgreSQL_PKG_LIBRARY_DIR}")
  # Install everything else into share-dir
  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.control
      ${EXTENSION_DATA}
    DESTINATION "${PostgreSQL_SHARE_DIR}/extension"
  )
endfunction()
