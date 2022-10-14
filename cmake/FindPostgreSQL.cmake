# Based on:
# https://cmake.org/cmake/help/latest/manual/cmake-developer.7.html#find-modules
# ----------------------------------------------------------------------------

# We will be configuring using pg_config
find_program(PG_CONFIG pg_config
  REQUIRED
  PATHS ${PostgreSQL_ROOT_DIRECTORIES}
  PATH_SUFFIXES bin)

execute_process(COMMAND ${PG_CONFIG} --bindir            OUTPUT_VARIABLE PostgreSQL_BIN_DIR            OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --docdir            OUTPUT_VARIABLE PostgreSQL_DOC_DIR            OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --htmldir           OUTPUT_VARIABLE PostgreSQL_HTML_DIR           OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --includedir        OUTPUT_VARIABLE PostgreSQL_INCLUDE_DIR        OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --pkgincludedir     OUTPUT_VARIABLE PostgreSQL_PKGINCLUDE_DIR     OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --includedir-server OUTPUT_VARIABLE PostgreSQL_INCLUDE_SERVER_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --libdir            OUTPUT_VARIABLE PostgreSQL_LIB_DIR            OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --pkglibdir         OUTPUT_VARIABLE PostgreSQL_PKGLIB_DIR         OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --localedir         OUTPUT_VARIABLE PostgreSQL_LOCALE_DIR         OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --mandir            OUTPUT_VARIABLE PostgreSQL_MAN_DIR            OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --sharedir          OUTPUT_VARIABLE PostgreSQL_SHARE_DIR          OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --cppflags          OUTPUT_VARIABLE PostgreSQL_CPPFLAGS           OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --cflags            OUTPUT_VARIABLE PostgreSQL_CFLAGS             OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --cflags_sl         OUTPUT_VARIABLE PostgreSQL_CFLAGS_SL          OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --ldflags           OUTPUT_VARIABLE PostgreSQL_LDFLAGS            OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --ldflags_ex        OUTPUT_VARIABLE PostgreSQL_LDFLAGS_EX         OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --ldflags_sl        OUTPUT_VARIABLE PostgreSQL_LDFLAGS_SL         OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --libs              OUTPUT_VARIABLE PostgreSQL_LIBS               OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${PG_CONFIG} --version           OUTPUT_VARIABLE PostgreSQL_VERSION            OUTPUT_STRIP_TRAILING_WHITESPACE)

message(STATUS "v ${PostgreSQL_VERSION}")

# Set version
# ----------------------------------------------------------------------------
string(REGEX MATCHALL "[0-9]+" PostgreSQL_VERSION_LIST "${PostgreSQL_VERSION}")
list(GET PostgreSQL_VERSION_LIST 0 PostgreSQL_VERSION_MAJOR)
list(GET PostgreSQL_VERSION_LIST 1 PostgreSQL_VERSION_MINOR)
set(PostgreSQL_VERSION "${PostgreSQL_VERSION_MAJOR}.${PostgreSQL_VERSION_MINOR}")

message(STATUS "PostgreSQL_VERSION = ${PostgreSQL_VERSION}")
message(STATUS "PostgreSQL_VERSION_MAJOR = ${PostgreSQL_VERSION_MAJOR}")
message(STATUS "PostgreSQL_VERSION_MINOR = ${PostgreSQL_VERSION_MINOR}")


# ----------------------------------------------------------------------------

# First, we try to use pkg-config to find the library. Note that we cannot rely on this, as it may not be available, but it provides a good starting point.
find_package(PkgConfig)
pkg_check_modules(PC_PostgreSQL
                  REQUIRED
                  IMPORTED_TARGET
                  libpq)

# This should define some variables starting PC_Foo_ that contain the information from the Foo.pc file.
message(STATUS "PC_PostgreSQL_FOUND = ${PC_PostgreSQL_FOUND}")
message(STATUS "PC_PostgreSQL_LIBRARIES = ${PC_PostgreSQL_LIBRARIES}")
message(STATUS "PC_PostgreSQL_LINK_LIBRARIES = ${PC_PostgreSQL_LINK_LIBRARIES}")
message(STATUS "PC_PostgreSQL_LIBRARY_DIRS = ${PC_PostgreSQL_LIBRARY_DIRS}")
message(STATUS "PC_PostgreSQL_LDFLAGS = ${PC_PostgreSQL_LDFLAGS}")
message(STATUS "PC_PostgreSQL_LDFLAGS_OTHER = ${PC_PostgreSQL_LDFLAGS_OTHER}")
message(STATUS "PC_PostgreSQL_INCLUDE_DIRS = ${PC_PostgreSQL_INCLUDE_DIRS}")
message(STATUS "PC_PostgreSQL_CFLAGS = ${PC_PostgreSQL_CFLAGS}")
message(STATUS "PC_PostgreSQL_CFLAGS_OTHER = ${PC_PostgreSQL_CFLAGS_OTHER}")

message(STATUS "PC_PostgreSQL_VERSION = ${PC_PostgreSQL_VERSION}")
message(STATUS "PC_PostgreSQL_PREFIX = ${PC_PostgreSQL_PREFIX}")
message(STATUS "PC_PostgreSQL_INCLUDEDIR = ${PC_PostgreSQL_INCLUDEDIR}")
message(STATUS "PC_PostgreSQL_LIBDIR = ${PC_PostgreSQL_LIBDIR}")

# Alternatively, if the library is available with multiple configurations, you can use SelectLibraryConfigurations to automatically set the Foo_LIBRARY variable instead:
find_library(PostgreSQL_LIBRARY_RELEASE
  NAMES postgres
  PATHS ${PC_PostgreSQL_LIBRARY_DIRS}/Release
)
find_library(PostgreSQL_LIBRARY_DEBUG
  NAMES postgres
  PATHS ${PC_PostgreSQL_LIBRARY_DIRS}/Debug
)

include(SelectLibraryConfigurations)
select_library_configurations(PostgreSQL)

# VERSION
# ----------------------------------------------------------------------------

# If you have a good way of getting the version (from a header file, for example),
# you can use that information to set Foo_VERSION (although note that find modules have traditionally used Foo_VERSION_STRING, so you may want to set both).

string(REGEX MATCHALL "[0-9]+" PostgreSQL_VERSION_LIST "${PostgreSQL_VERSION}")
list(GET PostgreSQL_VERSION_LIST 0 PostgreSQL_VERSION_MAJOR)
list(GET PostgreSQL_VERSION_LIST 1 PostgreSQL_VERSION_MINOR)
set(PostgreSQL_VERSION "${PostgreSQL_VERSION_MAJOR}.${PostgreSQL_VERSION_MINOR}")

#                     ------------------------------------

# Otherwise, attempt to use the information from pkg-config

# set(Foo_VERSION ${PC_PostgreSQL_VERSION})

# ----------------------------------------------------------------------------

# Now we can use FindPackageHandleStandardArgs to do
# most of the rest of the work for us
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PostgreSQL
  FOUND_VAR PostgreSQL_FOUND
  REQUIRED_VARS
    PostgreSQL_LIBRARY
    PostgreSQL_INCLUDE_DIR
  VERSION_VAR PostgreSQL_VERSION
)

# PROVIDE LINKAGE
# ----------------------------------------------------------------------------

# At this point, we have to provide a way for users of the find module to link to the library or libraries that were found. There are two approaches, as discussed in the Find Modules section above.

# The traditional variable approach looks like

# if(Foo_FOUND)
#   set(Foo_LIBRARIES ${Foo_LIBRARY})
#   set(Foo_INCLUDE_DIRS ${Foo_INCLUDE_DIR})
#   set(Foo_DEFINITIONS ${PC_Foo_CFLAGS_OTHER})
# endif()

#                     ------------------------------------

# When providing imported targets, these should be namespaced (hence the Foo:: prefix); CMake will recognize that values passed to target_link_libraries() that contain :: in their name are supposed to be imported targets (rather than just library names), and will produce appropriate diagnostic messages if that target does not exist (see policy CMP0028).

if(PostgreSQL_FOUND AND NOT TARGET PostgreSQL::PostgreSQL)
  add_library(PostgreSQL::PostgreSQL UNKNOWN IMPORTED)
  set_target_properties(PostgreSQL::PostgreSQL PROPERTIES
    IMPORTED_LOCATION "${PostgreSQL_LIBRARY}"
    INTERFACE_COMPILE_OPTIONS "${PC_PostgreSQL_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${PostgreSQL_INCLUDE_DIR}"
  )
endif()

#                     ------------------------------------

# If the library is available with multiple configurations, the IMPORTED_CONFIGURATIONS target property should also be populated:

# if(PostgreSQL_FOUND)
#   if (NOT TARGET PostgreSQL::PostgreSQL)
#     add_library(PostgreSQL::PostgreSQL UNKNOWN IMPORTED)
#   endif()
#   if (PostgreSQL_LIBRARY_RELEASE)
#     set_property(TARGET PostgreSQL::PostgreSQL APPEND PROPERTY
#       IMPORTED_CONFIGURATIONS RELEASE
#     )
#     set_target_properties(PostgreSQL::PostgreSQL PROPERTIES
#       IMPORTED_LOCATION_RELEASE "${PostgreSQL_LIBRARY_RELEASE}"
#     )
#   endif()
#   if (PostgreSQL_LIBRARY_DEBUG)
#     set_property(TARGET PostgreSQL::PostgreSQL APPEND PROPERTY
#       IMPORTED_CONFIGURATIONS DEBUG
#     )
#     set_target_properties(PostgreSQL::PostgreSQL PROPERTIES
#       IMPORTED_LOCATION_DEBUG "${PostgreSQL_LIBRARY_DEBUG}"
#     )
#   endif()
#   set_target_properties(PostgreSQL::PostgreSQL PROPERTIES
#     INTERFACE_COMPILE_OPTIONS "${PC_PostgreSQL_CFLAGS_OTHER}"
#     INTERFACE_INCLUDE_DIRECTORIES "${PostgreSQL_INCLUDE_DIR}"
#   )
# endif()

# ----------------------------------------------------------------------------

# The RELEASE variant should be listed first in the property so that the variant is chosen if the user uses a configuration which is not an exact match for any listed IMPORTED_CONFIGURATIONS.

# Most of the cache variables should be hidden in the ccmake interface unless the user explicitly asks to edit them.
mark_as_advanced(
  Foo_INCLUDE_DIR
  Foo_LIBRARY
)
