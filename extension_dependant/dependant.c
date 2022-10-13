#include <postgres.h> // Primary include file for PostgreSQL server .c files
#include <fmgr.h>     // Definitions for the Postgres function manager and function-call interface

#include <h3api.h>    // Dependency example

#include "shared.h"

PG_MODULE_MAGIC;

PGDLLEXPORT Datum dependant(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(dependant);

Datum dependant(PG_FUNCTION_ARGS) {
	H3Index		h3;

	char *string = PG_GETARG_CSTRING(0);
	H3Error error = stringToH3(string, &h3);
	if (error) {
    ereport(ERROR, (
      errcode(ERRCODE_EXTERNAL_ROUTINE_EXCEPTION),
      errmsg("h3 error code: %i", error)
    ));
  }
  int resolution = getResolution(h3);

  PG_RETURN_INT32(resolution);
}
