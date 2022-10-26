# Add pg_regress binary
find_program(PostgreSQL_REGRESS pg_regress
  HINTS
    "${PostgreSQL_PKG_LIBRARY_DIR}/pgxs/src/test/regress/"
    "${PostgreSQL_BIN_DIR}"
)

# Helper command to add extensions
function(PostgreSQL_add_extension LIBRARY_NAME)
  set(options RELOCATABLE)
  set(oneValueArgs NAME COMMENT)
  set(multiValueArgs SOURCES DATA)
  cmake_parse_arguments(EXTENSION "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # Default extension name to same as library name
  if(NOT EXTENSION_NAME)
    set(EXTENSION_NAME ${LIBRARY_NAME})
  endif()

  # Allow extensions without sources
  if(EXTENSION_SOURCES)
    # Add extension as a dynamically linked library
    add_library(${LIBRARY_NAME} MODULE ${EXTENSION_SOURCES})

    # Link extension to PostgreSQL
    target_link_libraries(${LIBRARY_NAME} PostgreSQL::PostgreSQL)

    # Fix apple missing symbols
    if(APPLE)
      set_target_properties(${LIBRARY_NAME} PROPERTIES LINK_FLAGS ${PostgreSQL_LINK_FLAGS})
    endif()

    # Final touches on output file
    set_target_properties(${LIBRARY_NAME} PROPERTIES
      OUTPUT_NAME ${EXTENSION_NAME}
      INTERPROCEDURAL_OPTIMIZATION TRUE
      #C_VISIBILITY_PRESET hidden # @TODO: how to get this working?
      PREFIX "" # Avoid lib* prefix on output file
    )

    # Install .so/.dll to pkglib-dir
    install(TARGETS ${LIBRARY_NAME} LIBRARY DESTINATION "${PostgreSQL_PKG_LIBRARY_DIR}")
  endif()

  # Generate .control file
  configure_file(
    ${CMAKE_SOURCE_DIR}/cmake/control.in
    ${EXTENSION_NAME}.control
  )

  # Install everything else into share-dir
  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/${EXTENSION_NAME}.control
      ${EXTENSION_DATA}
    DESTINATION "${PostgreSQL_SHARE_DIR}/extension"
  )
endfunction()
