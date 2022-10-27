-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION dependant" to load this file. \quit

CREATE FUNCTION dependant(cstring)
    RETURNS integer
    AS 'dependant'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION
    h3_great_circle_distance(a point, b point, unit text DEFAULT 'km') RETURNS double precision
AS 'h3' LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE; COMMENT ON FUNCTION
    h3_great_circle_distance(point, point, text)
IS 'The great circle distance in radians between two spherical coordinates.';
