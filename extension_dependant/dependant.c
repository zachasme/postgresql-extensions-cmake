#include <postgres.h> // Primary include file for PostgreSQL server .c files
#include <fmgr.h>     // Definitions for the Postgres function manager and function-call interface

#include "shared.h"

PG_MODULE_MAGIC;

PGDLLEXPORT Datum dependant(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(dependant);

Datum dependant(PG_FUNCTION_ARGS) {
  int arg = PG_GETARG_INT32(0);
  PG_RETURN_INT32(arg);
}
