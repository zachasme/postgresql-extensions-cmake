#include <postgres.h> // Primary include file for PostgreSQL server .c files
#include <fmgr.h>     // PG_FUNCTION_INFO_V1
#include <utils/geo_decls.h> // making native points
#include <utils/builtins.h> // making native points

#include <h3api.h>    // Dependency example

#include "shared.h"

PG_MODULE_MAGIC;

PGDLLEXPORT PG_FUNCTION_INFO_V1(dependant);
PGDLLEXPORT PG_FUNCTION_INFO_V1(h3_great_circle_distance);

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

Datum
h3_great_circle_distance(PG_FUNCTION_ARGS)
{
	Point	   *aPoint = PG_GETARG_POINT_P(0);
	Point	   *bPoint = PG_GETARG_POINT_P(1);
	char	   *unit = text_to_cstring(PG_GETARG_TEXT_PP(2));

	LatLng		a;
	LatLng		b;
	double		distance;

	a.lng = degsToRads(aPoint->x);
	a.lat = degsToRads(aPoint->y);
	b.lng = degsToRads(bPoint->x);
	b.lat = degsToRads(bPoint->y);

	if (strcmp(unit, "rads") == 0)
		distance = greatCircleDistanceRads(&a, &b);
	else if (strcmp(unit, "km") == 0)
		distance = greatCircleDistanceKm(&a, &b);
	else if (strcmp(unit, "m") == 0)
		distance = greatCircleDistanceM(&a, &b);
	else
   ereport(ERROR, (
      errcode(ERRCODE_INVALID_PARAMETER_VALUE),
      errmsg("Unit must be m, km or rads.")
    ));

	PG_RETURN_FLOAT8(distance);
}
