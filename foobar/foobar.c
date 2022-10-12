#include "postgres.h"
#include <fmgr.h>

PG_MODULE_MAGIC;

PGDLLEXPORT Datum foobar(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(foobar);

Datum foobar(PG_FUNCTION_ARGS) {
  int arg = PG_GETARG_INT32(0);
  PG_RETURN_INT32(arg);
}
